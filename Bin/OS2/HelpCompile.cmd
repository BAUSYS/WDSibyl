/* HelpCompile.cmd */

a=Arg(1)
shs = word(a,1)
out = word(a,2)
lng = translate(word(a,3)," ",",")
say a
say "Shs-File:" shs
say "Ouptut:" out
say "Language:" lng 

d1=lastpos("\",shs)+1
file=substr(shs, d1, lastpos(".",shs)-d1)
rv=directory(out)

do cnt=1 to words(lng)
  f=out"\"file"_"word(lng,cnt)
  ipf=f".IPF"
  hlp=f".HLP"
  say "Compile:" ipf
  "F:\Sprachen\HLP\IPFC\IPFC" ipf hlp
end 


say "HelpCompile - Taste drÅcken"
pull text 
