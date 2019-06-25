module circuit13(o, i);
    input wire [5:0] i;
    output wire [0:0] o;
    wire [6:0] w;

    and (w[0], i[0], i[1]);
    not (w[1], i[2]);
    or (w[2], i[3], i[4]);
    or (w[3], w[1], w[2]);
    not (w[4], w[3]);
    and (w[5], w[0], w[3]);
    or (w[6], w[4], i[5]);
    and (o, w[5], w[6]);
endmodule

