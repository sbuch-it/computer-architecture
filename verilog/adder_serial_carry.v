module sommatore_parallelo_con_riporto_seriale(a,b,cin,s,cout);
  input [N-1:0] a, b; wire a, b;
  input cin; wire cin;
  output [N-1:0] s; wire [N-1:0] s;
  output cout; wire cout;

  parameter N = 32; // bits
  wire [N-1:0] _c;
  assign cout = _c[N-1];
  full_adder add0(a[0], b[0], cin, s[0], _c[0]);
  // "add0" rappresenta un'istanza di full_adder
  genvar i;
  // Le variabili "genvar" spariscono dopo
  // l'elaborazione del codice (non diventano circuiti)
  generate
    for (i = 1; i < N; i = i + 1)
      begin : gen_adder
      full_addera ddN(a[i], b[i], _c[i-1], s[i], _c[i]);
      // "addN" rappresenta un'istanza di full_adder
      end
  endgenerate
endmodule
