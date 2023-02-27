// made by teacher
// N-bit OR

module orN #(parameter N = 8) (
    input logic [N - 1 : 0] x,
    output logic y
);
    assign y = |x;
endmodule