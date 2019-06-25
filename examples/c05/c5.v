module circuit5(o, i);
    input wire [3:0] i;
    output wire [0:0] o;
    wire [4:0] w;

    or (w[0], i[0], i[1]);
    not (w[1], i[2]);
    and (w[2], w[1], i[3]);
    not (w[3], w[0]);
    not (w[4], w[2]);
    or (o, w[3], w[4]);
endmodule
