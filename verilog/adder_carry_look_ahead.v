module cla_full_adder(a, b, c, g, p, s);
    input a, b, c;
    output g, p, s;
    assign g = a & b;
    assign p = a ^ b;
    assign s = a ^ (b ^ c);
endmodule

