module circuit15(o, i);
    input wire [5:0] i;
    output wire [0:0] o;
    wire [6:0] w;
    
    and (w[0], i[0], i[1]);
    and (w[1], i[2], i[3]);
    or (w[2], i[4], i[5]);
    or (w[3], w[0], w[1]);
    or (w[4], w[1], w[2]);
    xor (o, w[3], w[4]);
endmodule