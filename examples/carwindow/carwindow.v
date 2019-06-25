module CarWindowController(s, n, i, clk);
    output reg [2:0] s = 000;
    output wire [2:0] n;
    input wire [2:0] i;
    input wire clk;
    wire w [28:0];
    
    not (w[0], i[0]);
    not (w[1], i[1]);
    not (w[2], s[0]);
    not (w[3], s[1]);
    not (w[4], s[2]);
    
    and (w[5], s[2], w[1]);
    and (w[6], s[2], i[0]);
    and (w[7], s[0], i[1]);
    and (w[8], s[1], w[0]);
    and (w[9], s[0], w[1]);
    and (w[10], s[1], w[2]);
    and (w[11], s[2], i[1]);
    and (w[12], w[4], w[1]);
    and (w[13], s[1], i[1]);

    and (w[14], w[3], w[7]);
    and (w[15], w[0], w[9]);
    and (w[16], i[1], w[10]);
    and (w[17], s[1], w[9]);
    and (w[18], w[0], w[11]);
    and (w[19], i[0], w[12]);
    and (w[20], w[0], w[13]);
    and (w[21], i[1], w[8]);
    and (w[22], i[0], w[14]);
    
    or (w[23], w[5], w[6]);
    or (w[24], w[8], w[15]);
    or (w[25], w[19], w[20]);
    or (w[26], w[16], w[24]);
    or (w[27], w[21], w[25]);
    or (w[28], w[17], w[26]);
    or (n[2], w[22], w[23]);
    or (n[1], w[18], w[28]);
    or (n[0], w[18], w[27]);

    always (@posedge clk) s <- n;
endmodule