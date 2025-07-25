/*
Module	: 256x8-bit instruction memory (16-Byte blocks)
Author	: Isuru Nawinne
Date		: 10/06/2020

Description	:

This file presents a primitive instruction memory module for CO224 Lab 6 - Part 3
This memory allows instructions to be read as 16-Byte blocks
*/

module instruction_memory(
	input clock,
	input read,
	input [5:0] address,
	output reg [127:0] readinst,
	output reg busywait
);

reg readaccess;

//Declare memory array 1024x8-bits 
reg [7:0] memory_array [1023:0];
integer i;


//Initialize instruction memory
initial
begin
	busywait = 0;
	readaccess = 0;
	
	// Default all memory to NOP (or 0)
    for (i = 0; i < 1024; i = i + 1) begin
        memory_array[i] = 8'b00000000;
    end

    // Sample program given below. You may hardcode your software program here, or load it from a file:
    {memory_array[10'd3],  memory_array[10'd2],  memory_array[10'd1],  memory_array[10'd0]}  = 32'b00011001_00000000_00000100_00000000; // loadi 4 #25
    {memory_array[10'd7],  memory_array[10'd6],  memory_array[10'd5],  memory_array[10'd4]}  = 32'b00100011_00000000_00000101_00000000; // loadi 5 #35
    {memory_array[10'd11], memory_array[10'd10], memory_array[10'd9],  memory_array[10'd8]}  = 32'b00000101_00000100_00000110_00000010; // add 6 4 5
    {memory_array[10'd15], memory_array[10'd14], memory_array[10'd13], memory_array[10'd12]} = 32'b01011010_00000000_00000001_00000000; // loadi 1 #90
    {memory_array[10'd19], memory_array[10'd18], memory_array[10'd17], memory_array[10'd16]} = 32'b00000100_00000001_00000001_00000011; // sub 1 1 4

	//$readmemb("instr_mem_cache.mem", memory_array);

end

//Detecting an incoming memory access
always @(read)
begin
    busywait = (read)? 1 : 0;
    readaccess = (read)? 1 : 0;
end

//Reading
always @(posedge clock)
begin
	if(readaccess)
	begin
		readinst[7:0]     = #40 memory_array[{address,4'b0000}];
		readinst[15:8]    = #40 memory_array[{address,4'b0001}];
		readinst[23:16]   = #40 memory_array[{address,4'b0010}];
		readinst[31:24]   = #40 memory_array[{address,4'b0011}]; // -------
		readinst[39:32]   = #40 memory_array[{address,4'b0100}];
		readinst[47:40]   = #40 memory_array[{address,4'b0101}];
		readinst[55:48]   = #40 memory_array[{address,4'b0110}];
		readinst[63:56]   = #40 memory_array[{address,4'b0111}]; // -------
		readinst[71:64]   = #40 memory_array[{address,4'b1000}];
		readinst[79:72]   = #40 memory_array[{address,4'b1001}];
		readinst[87:80]   = #40 memory_array[{address,4'b1010}];
		readinst[95:88]   = #40 memory_array[{address,4'b1011}]; // -------
		readinst[103:96]  = #40 memory_array[{address,4'b1100}];
		readinst[111:104] = #40 memory_array[{address,4'b1101}];
		readinst[119:112] = #40 memory_array[{address,4'b1110}];
		readinst[127:120] = #40 memory_array[{address,4'b1111}]; // -------
		busywait = 0;
		readaccess = 0;
	end
end
 
endmodule