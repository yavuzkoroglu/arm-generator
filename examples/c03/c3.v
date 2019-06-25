module circuit3(o, i);
    input wire [3:0] i;
    output wire [0:0] o;
    wire [1:0] w;
    
    and (w[0], i[0], i[1]);
    and (w[1], i[2], i[3]);
    or (o, w[0], w[1]);
endmodule