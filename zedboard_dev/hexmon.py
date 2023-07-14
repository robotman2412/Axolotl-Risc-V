#!/usr/bin/env python3

import os, sys, termios, tty, fcntl, serial, time, select

class raw(object):
	def __init__(self, stream):
		self.stream = stream
		self.fd = self.stream.fileno()
	def __enter__(self):
		self.original_stty = termios.tcgetattr(self.stream)
		tty.setcbreak(self.stream, termios.TCSANOW)
	def __exit__(self, type, value, traceback):
		termios.tcsetattr(self.stream, termios.TCSANOW, self.original_stty)

class nonblocking(object):
	def __init__(self, stream):
		self.stream = stream
		self.fd = self.stream.fileno()
	def __enter__(self):
		self.orig_fl = fcntl.fcntl(self.fd, fcntl.F_GETFL)
		fcntl.fcntl(self.fd, fcntl.F_SETFL, self.orig_fl | os.O_NONBLOCK)
	def __exit__(self, *args):
		fcntl.fcntl(self.fd, fcntl.F_SETFL, self.orig_fl)



fd = None



def find_serial_ports():
	"""Finds serial ports."""
	devs = os.listdir("/dev")
	out = []
	for dev in devs:
		if dev.startswith("ttyUSB") or dev.startswith("ttyACM"):
			out += ["/dev/" + dev]
	return out


def pick_serial_port(max_disp=9):
	"""Selects a serial port."""
	# Get serial ports list.
	devs = find_serial_ports()
	if len(devs) == 0:
		raise FileNotFoundError("No serial ports found")
	elif len(devs) == 1:
		print("Using serial port " + devs[0])
		return devs[0]
	# List them all.
	print("Found {} serial port{}:".format(len(devs), 's' if len(devs) != 1 else ''))
	for i in range(min(max_disp, len(devs))):
		print("  #{:d}  {}".format(i+1, devs[i]))
	# Excessive text.
	if len(devs) > max_disp:
		print("... ({} more)".format(len(devs) - max_disp))
	# Ask for a selection.
	while True:
		try:
			sel = input("Select serial port ({}): ".format(devs[0]))
		except KeyboardInterrupt or EOFError:
			exit(1)
		if sel in devs: return sel
		if len(sel) == 0: return devs[0]
		if len(sel) >= 2 and sel[0] == '#':
			try:
				n = int(sel[1:])
				if n >= 1 and n <= len(devs): return devs[n-1]
			except ValueError:
				pass


def pick_baud_rate(default=9600):
	"""Selects the BAUD RATE."""
	# TODO.
	return 9600


def print_help():
	"""Prints the HELP TEXT."""
	ports=find_serial_ports()
	if len(ports):
		print("Usage: {} [port={}] [baudrate=9600]".format(sys.argv[0], ports[0]))
	else:
		print("Usage: {} [port=<no ports detected>] [baudrate=9600]".format(sys.argv[0]))


def hexdump(str, prefix="", cols=16):
	"""Prints a HEX DUMP."""
	for y in range(0, (len(str)-1)//cols+1):
		print(prefix+"{:02x}:".format(y*cols), end="")
		for x in range(cols):
			if x % 4 == 0: print(" ", end="")
			if x+y*cols < len(str):
				print(" {:02x}".format(str[y*cols+x]), end="")
			else:
				print("   ", end="")
		print("  ", end="")
		for x in range(min(cols, len(str)-cols*y)):
			if str[y*cols+x] >= 20 and str[y*cols+x] <= 126:
				print(chr(str[y*cols+x]), end="")
			else:
				print(".", end="")
		print()


def grabline(raw: str):
	"""Grabs a LINE from the STRING."""
	if '\r' in raw and '\n' in raw:
		cr = raw.index('\r')
		lf = raw.index('\n')
		if lf == cr + 1:
			return raw[:cr], raw[lf+1:]
		elif lf < cr:
			return raw[:lf], raw[lf+1:]
		else: # cr < lf:
			return raw[:cr], raw[cr+1:]
	elif '\r' in raw:
		cr = raw.index('\r')
		return raw[:cr], raw[cr+1:]
	elif '\n' in raw:
		lf = raw.index('\n')
		return raw[:lf], raw[lf+1:]
	else:
		return raw, ""


def grabtoken(raw: str):
	"""Grabs a TOKEN from the STRING."""
	wordc = "0123456789ABCDEFGHIJLKMNOPQRSTUVWXYZabcdefghijlkmnopqrstuvwxyz_"
	# Remove leading writespace.
	raw = raw.lstrip()
	if len(raw) == 0:
		return None, ""
	elif raw[0] in wordc:
		# Grab WORD.
		for i in range(len(raw)):
			if raw[i] not in wordc:
				return raw[:i], raw[i:]
		return raw, ""
	elif raw[0] == '\'' or raw[0] == '\"':
		# Grab STRING.
		esc = False
		out = ''
		for i in range(1, len(raw)):
			if esc:
				if raw[i] in '\'\"\\':
					out += raw[i]
				elif raw[i] == 'r':
					out += '\r'
				elif raw[i] == 'n':
					out += '\n'
				elif raw[i] == 'b':
					out += '\b'
				elif raw[i] == 't':
					out += '\t'
				elif raw[i] == 'f':
					out += '\f'
				elif raw[i] == '0':
					out += '\0'
				else:
					raise ValueError("Unknown escape sequence")
				esc = False
			elif raw[i] == '\\':
				esc = True
			elif raw[i] == raw[0]:
				return raw[0] + out + raw[0], raw[i+1:]
			else:
				out += raw[i]
		raise ValueError("Unclosed string")
	else:
		return raw[0], raw[1:]


def cmd_help(fd: serial.Serial, cmd: str, line: str):
	"""Handles a HELP cmd."""
	print("Available commands:")
	print()
	print("  ?  h  help")
	print("        Show this help text")
	print()
	print("  t  tx  transmit  send")
	print("        Send data")
	print()
	print("  q  quit  exit  stop")
	print("        Exit the monitor")


def tobytes(val: int, bytecount: int = 4, littleendian: bool = True) -> bytes:
	"""Converts an integer to a bytes object."""
	val = int(val)
	if val < 0:
		val = val & ((1<<(8*bytecount))-1)
	if littleendian:
		return bytes((val >> (8*i)) & 255 for i in range(bytecount))
	else:
		return bytes((val >> (8*i)) & 255 for i in range(bytecount-1, -1, -1))


def cmd_transmit(fd: serial.Serial, cmd: str, line: str):
	"""Handles a TRANSMIT cmd."""
	txbuf   = b''
	cursize = 4
	tkn     = None
	while True:
		try:
			tkn, line = grabtoken(line)
		except ValueError as e:
			print(e)
			return
		nextval = None
		if not tkn: break
		elif tkn.lower() in [ "i64", "u64" ]:
			cursize = 8
		elif tkn.lower() in [ "i32", "u32" ]:
			cursize = 4
		elif tkn.lower() in [ "i16", "u16" ]:
			cursize = 2
		elif tkn.lower() in [ "i8", "u8" ]:
			cursize = 1
		elif tkn[:2] in [ "0x", "0X" ]:
			try:
				nextval = int(tkn[2:], 16)
			except:
				print("Invalid hexadecimal: {}".format(tkn))
				return
		elif tkn[:2] in [ "0o", "0O", "0q", "0Q" ]:
			try:
				nextval = int(tkn[2:], 16)
			except:
				print("Invalid hexadecimal: {}".format(tkn))
				return
		elif tkn[0] in '0123456789':
			try:
				nextval = int(tkn)
			except:
				print("Invalid decimal: {}".format(tkn))
				return
		elif tkn[0] in "\'\"":
			txbuf += tkn[1:-1].encode()
		else:
			print("Unknown token: {}".format(tkn))
		if nextval != None:
			txbuf += tobytes(nextval, cursize)
	hexdump(txbuf, "> ")
	fd.write(txbuf)


def handlecmd(fd: serial.Serial, line: str):
	"""Handles a COMMAND."""
	try:
		cmd, line = grabtoken(line)
		if not cmd: return
		cmd = cmd.lower()
		if cmd in ['?', "h", "help"]:
			cmd_help(fd, cmd, line)
		elif cmd in ['t', "tx", "transmit", "send"]:
			cmd_transmit(fd, cmd, line)
		elif cmd in ['q', "quit", "exit", "stop"]:
			exit(0)
		else:
			print("Unknown command '{}'.".format(cmd))
			print("Type ? for help")
	except ValueError as e:
		print(e)
		return


def tty_loop(fd: serial.Serial):
	"""Implements the TTY FUNCTION."""
	txbuf=''
	rxbuf=b''
	while True:
		r, w, x = select.select([sys.stdin.fileno(), fd.fileno()], [], [], 0.1)
		time.sleep(0.01)
		avl = fd.read_all()
		rxbuf += avl
		if rxbuf and len(rxbuf) and len(avl) == 0:
			# TODO: Remove about-to-send from TTY.
			hexdump(rxbuf, "< ")
			# TODO: Reprint about-to-send from TTY.
			rxbuf=b''
		avl = sys.stdin.read(1)
		if avl and len(avl):
			if avl == '\x7f' or avl == '\b':
				txbuf = txbuf[:-1]
				print("\b \b", end="")
			else:
				txbuf += avl
				print(avl, end="")
			sys.stdout.flush()
			if '\r' in txbuf or '\n' in txbuf:
				line, txbuf = grabline(txbuf)
				handlecmd(fd, line)
		


if __name__ == "__main__":
	# ARGPARSE
	if len(sys.argv) < 1 or len(sys.argv) > 3:
		print_help()
		exit(1)
	
	try:
		if len(sys.argv) >= 2:
			port = sys.argv[1]
		else:
			port = pick_serial_port()
		
		if len(sys.argv) >= 3:
			baud = int(sys.argv[2])
		else:
			baud = pick_baud_rate()
	except:
		exit(1)
	
	print("Type CTRL+D to exit")
	fd = serial.Serial(port, baud)
	
	with raw(sys.stdin):
		with nonblocking(sys.stdin):
			tty_loop(fd)
