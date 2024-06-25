.text
.globl exp  #importante per la chiamata

exp: 

   fmv.s.x ft5, a3       #convertiamo l'input in float
   fmul.s ft5, ft5, ft5  #moltiplicazione float
   fmv.x.s a0, ft5       #convertiamo e restituiamo valore
   ret                   #exit
