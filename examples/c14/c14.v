module circuit14(o, i);
    input wire [5:0] i;
    output wire [0:0] o;
    wire [9:0] w;
    
    not (w[0], i[0]);
    and (w[1], i[1], i[2]);
    or (w[2], i[3], i[4]);
    not (w[3], i[5]);
    or (w[4], w[0], w[1]);
    and (w[5], w[1], w[2]);
    and (w[6], w[2], w[3]);
    or (w[7], w[4], w[5]);
    or (w[8], w[5], w[6]);
    or (w[9], w[7], w[8]);
    not (o, w[9]);
endmodule