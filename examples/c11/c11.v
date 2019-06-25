module circuit11(o, i);
    input wire [5:0] i;
    output wire [0:0] o;
    wire [6:0] w;

    or (w[0], i[0], i[1]);
    or (w[1], i[2], i[3]);
    and (w[2], i[4], i[5]);
    not (w[3], w[0]);
    not (w[4], w[1]);
    or (w[5], w[1], w[3]);
    and (w[6], w[2], w[4]);
    and (o, w[5], w[6]);
endmodule

