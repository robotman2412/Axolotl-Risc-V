# Axolotl³² debug specification
Due to the complexity required by the RISC-V debug specification, Axo32 uses a custom debug specification.
The "Axolotl³² debug port" (AxoDebug for short) is a little-endian, synchronous, transactional, register-based protocol built on UART, I²C or SPI.



# Transport layer
In abstract, the communication is 8-bit serial starting with some amount of transport-specific header information, followed by two bytes of register address.
Internally, AxoDebug uses a 16-bit register address and an 8-bit data bus with RE/WE/clock inputs.
Any multi-byte registers are accessed little-endian and sign-extended on partial write.

## UART
When communicating over UART, AxoDebug uses at least 1 millisecond of silence as the end of transmission indicator.
The baud rate for UART communication is 115200, 1 start bit, 1.5 stop bits, no parity bit.

The first byte send by the master is the read/write indicator; 1 is read, 0 is write.
The second byte is the transaction length minus one; a value of 0 means 1 byte accessed, a value of 1 means 2 bytes, etc.
The third and third fourth sent by the master are the register address.
The subsequent bytes are either sent by the master as write data or received from the slave within 100us as read data.

## SPI
When communicating over SPI, AxoDebug uses falling edge of chip select as the start of transaction.
The bitrate of SPI is up to 1MHz.

The first byte is sent by the master; the read/write indicator; 1 is read, 0 is write.
The second and third bytes are also sent by the master; the register address.
The fourth and subsequent bytes are either from the slave in case of a read, or from the master in case of a write.

For SPI-like busses where full duplex is supported, the side that is not sending data shall use the value 0xff instead.

## I²C
When communicating over I²C, AxoDebug uses the I²C address 0x5E.
The bitrate of I²C is up to 1MHz.

The first two bytes written by the controller are the AxoDebug register.
The remaining bytes are either written in the same transaction when writing the register, or read in a repeated start or next transaction when reading the register.



# Register map

Debug registers, GPRs and CSRs a memory window are mapped into a 16-bit debug address space. The range for 0x0000 to 0x7FFFF is part of the debugging hardware and exists outside of the selected HART. The range from 0x8000 to 0xFFFF exists per HART and represents physical hardware within the HART.

| Address       | Name    | Description
| :------------ | :------ | :----------
| 0x0000        | xrdver  | Debug interface version register.
| 0x0001        | xrderr  | Error status of previous transaction.
| 0x0002        | xrdhart | Current HART ID and select.
| 0x0003        | xrdmax  | (read-only) Maximum valid xrdhart value.
| 0x0004        | xrdrun  | Current HART run and reset status.
| 0x0005        | xrdisa  | Current HART supported instruction sets.
| 0x0006        | memaddr | Current memory address for memport.
| 0x0007        | memport | Access memory using the current HART's data bus.
| 0x0008        | memctl  | Memory access mode register.
| 0x8000        | pc      | Next instruction pointer.
| 0x8001-0x801F | x1-x31  | Integer registers.
| 0x8020-0x803F | f0-f31  | Floating-point registers.
| 0x9000-0x9FFF | -       | Control and status registers.

## xrdver
The maximum supported protocol version of the AxoDebug port.

Size: 1 byte

Valid values: 0

## xrderr
Error status of previous transaction.
If nonzero, contains an error code from the following table:

| ID  | Name       | Description
| :-- | :--------- | :----------
| 1   | e_protocol | Protocol not adhered to
| 2   | e_reg      | Requested register not available
| 3   | e_memread  | Memory read failed
| 4   | e_memwrite | Memory write failed
| 5   | e_nohart   | Selected HART is not present or not available

Size: 1 byte

Valid values: 0-255

## xrdhart
The ID of the currently selected HART, equal to it's `mhartid` CSR.

Size: 4 bytes

Valid values: 0-0xffffffff

## xrdmax
(read-only) The maximum valid value of `xrdhart`. Some of the values 0 < N < `xrdhart` may not have a RISC-V hart present. For these values, the `present` bit in `xrdrun` is cleared.

Size: 4 bytes

Valid values: implementation-defined.

## xrdrun
Control and status register of the current HART.

| Bit | Name      | Description
| :-- | :-------- | :----------
| 0   | present   | (read-only) This HART exists.
| 1   | available | (read-only) This HART exists and can be interfaced with.
| 2   | reset     | This HART is in reset.
| 3   | run       | This HART is running code normally.
| 4   | xlen      | XLEN of this HART is 64-bit instead of 32-bit.
| 5   | flen32    | At least the single-precision floating-point extension is supported.
| 6   | flen64    | At least the double-precision floating-point extension is supported.

*Note: When a HART exits a reset state, `available` may be 0 for a brief period of time until the HART is usable.*

Size: 4 bytes

## xrdisa
Null-terminated ASCII string representing the maximum supported ISA.
Optionally, the versions of each instruction set may be specified (e.g. "rv32i2p0" instead of just "rv32i")

Size: implementation-defined

Example value: rv32imafdc_sv32_zifencei_zicsr

## memaddr
The current address in memory to access using `memport`.
This address is incremented for every byte read or written using `memport`.

Size: XLEN

## memport
Memory access port; any reads/writes here correspond to reads/writes from the HART's perspective.
For every byte read or written, `memaddr` is incremented.

Size: infinite


## memctl
Defines the methods to use for accessing memory through `memport`.

| Bit | Name    | Description
| :-- | :------ | :----------
| 0   | virtual | Access virtual memory instead of physical memory.
| 1   | cached  | Allow the usage of caching, if present.

Size: 4 bytes

## pc
Program counter of the current HART; points at the next instruction that would be fetched if the HART were to be running.
As per RISC-V specification, bit 0 is masked and bit 1 is masked if the compressed instruction extension is not active.

Size: XLEN-1 or XLEN-2

## x1-x31
Integer registers of the current HART.

Size: XLEN

## f0-f31
Floating-point registers of the current HART.

Size: FLEN

