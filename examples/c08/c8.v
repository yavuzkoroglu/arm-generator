module circuit8(o, i);
    input wire [5:0] i;
    output wire [0:0] o;
    wire [6:0] w;

    or (w[0], i[0], i[1]);
    and (w[1], i[2], i[3]);
    not (w[2], i[4]);
    or (w[3], w[2], i[5]);
    not (w[4], w[0]);
    not (w[5], w[3]);
    or (w[6], w[1], w[5]);
    or (o, w[4], w[6]);
endmodule