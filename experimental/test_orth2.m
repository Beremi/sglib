n=5;
H1=hermite(n,true);
H1=H1(:,end:-1:1)
[i,j,s]=find(spones(ones(n+1)));
s(:)=0;
fun=@(m)(mod(m+1,2).*factorial(m)./(2.^(m/2).*factorial(floor(m/2))));
fun(1:10);
s=fun(i+j-2);
hh=full(sparse(i,j,s));
hh;
S=diag(sqrt(factorial(0:n)));
L=chol(hh)';
Q=(L'\Q)';
H2=S*inv(L);
H3=(L'\S)';
H1*hh*H1'
H2*hh*H2'
H3*hh*H3'
norm(H1-H2)
norm(H1-H3)
