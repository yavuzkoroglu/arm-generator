module circuit6(o, i);
    input wire [3:0] i;
    output wire [0:0] o;
    wire [4:0] w;

    and (w[0], i[0], i[1]);
    or (w[1], i[2], i[3]);
    not (w[2], w[0]);
    not (w[3], w[1]);
    or (w[4], w[2], w[3]);
    not (o, w[4]);
endmodule