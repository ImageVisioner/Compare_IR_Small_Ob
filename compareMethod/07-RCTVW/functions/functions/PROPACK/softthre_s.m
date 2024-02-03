function out=softthre_s(a,tau,w)
out = sign(a).* max( abs(a) - tau*w, 0);
end