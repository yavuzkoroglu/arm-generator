module circuit7(o, i);
    input wire [5:0] i;
    output wire [0:0] o;
    wire [4:0] w;

    and (w[0], i[0], i[1]);
    or (w[1], i[2], i[3]);
    and (w[2], i[4], i[5]);
    not (w[3], w[1]);
    and (w[4], w[2], w[3]);
    and (o, w[0], w[4]);
endmodule