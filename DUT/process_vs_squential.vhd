\
process can contatain both squential and concurent code

squential in process:

-------------------------------
if(rst) then
    a<='0';
elsif(raising(clk)) then
    a<=b;
end if; -- no need for default value like (else ...)

-------------------------------
case a is
    when cond1 =>
        b1 <= c1;
        b2 <= c2;
    when cond2 =>
        b1 <= d1;
        b2 <= d2;
    when others =>
        b1 <= e1;
        b2 <= e2;
end case;


-------------------------------
concurent: (prefarbly outside process but not a must)
-------------------------------

with A select
    B <= val1 when cond1,
         val2 when cond2,
         val3 when others;

-------------------------------
a <= val1 when cond1 else val2;

a <= val1 when cond1 else
     val2 when cond2 else
     val3;

-------------------------------
some_signal <= other_signal1 and other_signal2 or other_signal3;

-------------------------------
label: entety_name
general map(n,m)
port map(x,y, open); -- open mean that the wire is not connected

--------------------------------
if a=b then
    c <= d;
else
    c <= e;
end if;

--------------------------------
label: for i in 0 to n-1 generate
    a(i) <= val(i+1) when cond else '0';
end for;

label: for i in 0 to n-1 generate
    label2: entety_name port map(
        a <= val(i), b<='1';
    )
end for;

--------------------------------
function func_name(variable: a,b:integer) is
    variable tmp :boolean;
    begin
        if a<b then
            tmp := true;
        else
            tmp := false;
        end if;
        return tmp;
end function