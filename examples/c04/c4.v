module circuit4(o, i);
    input wire [3:0] i;
    output wire [0:0] o;
    wire [2:0] w;

    and (w[0], i[0], i[1]);
    or (w[1], i[2], i[3]);
    or (w[2], w[0], w[1]);
    not (o, w[2]);
endmodule