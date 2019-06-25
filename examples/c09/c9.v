module circuit9(o, i);
    input wire [5:0] i;
    output wire [0:0] o;
    wire [6:0] w;

    or (w[0], i[0], i[1]);
    or (w[1], i[2], i[3]);
    not (w[2], i[4]);
    and (w[3], w[2], i[5]);
    not (w[4], w[1]);
    and (w[5], w[0], w[4]);
    or (w[6], w[3], w[5]);
    not (o, w[6]);
endmodule

