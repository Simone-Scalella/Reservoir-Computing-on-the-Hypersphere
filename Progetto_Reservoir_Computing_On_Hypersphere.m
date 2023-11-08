% Programma per il test del metodo "Reservoir computing on the hypersphere (Andrecut (2017)"
% di Simone Scalella e Yihang Zhang (CdS - Informatica e Automazione, UnivPM)
% Rivisto da S. Fiori (DII, UnivPM) - Ottobre 2020
clc; clear; close all;

% Stringa di prova
s = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse mi tellus, tempus id dictum et, pharetra et lorem."+...
    "Praesent nulla purus, porttitor nec ligula at, rutrum hendrerit leo. Nunc quis metus urna. Praesent nec pellentesque dui."+... 
    "Donec blandit libero ac lacus commodo vulputate. Etiam ut dapibus dui, a scelerisque libero. Morbi convallis euismod nulla,"+... 
    "eget dignissim magna mollis sed. Fusce sagittis at arcu fringilla sagittis. Maecenas dolor turpis, pellentesque vitae nulla eu,"+... 
    "fringilla congue lorem. Vivamus feugiat placerat eros non vestibulum. Nunc consequat sed lectus sit amet commodo."+...
    "Curabitur eget risus auctor, congue mauris in, consectetur ex. Pellentesque dapibus at turpis commodo facilisis.";
    "Nam turpis mi, condimentum sed enim vel, condimentum placerat eros. Nullam placerat lorem magna, eget feugiat ante dictum sed."+... 
    "Phasellus efficitur hendrerit nisl non interdum. Aenean molestie mi felis, ullamcorper venenatis dui pulvinar et. "+...
    "Praesent rhoncus at mi in pretium. Aenean nec felis libero. Nullam pharetra ullamcorper neque, ut aliquam ex volutpat eget."+... 
    "Aenean facilisis non sapien a ultricies. Cras sit amet ex eget sapien ullamcorper commodo. Nulla sit amet est neque. Ut nec imperdiet tortor."+... 
    "In pulvinar quam est, non pellentesque urna dapibus in. Aenean felis nisi, convallis sed congue ac, pulvinar ut erat."; % Quisque quis neque quis velit sollicitudin pharetra sit amet tincidunt quam. Donec condimentum dui non risus tempor scelerisque. Praesent et tristique nulla. Vestibulum lacinia diam risus, sollicitudin mollis urna aliquet quis. Phasellus eu accumsan nisi. Aliquam erat volutpat. Curabitur et ligula non dui pharetra cursus. Pellentesque in porttitor velit. Aenean molestie dui non consequat aliquam. Proin viverra purus metus, vel suscipit metus cursus a. Quisque luctus consequat ante, in ullamcorper urna imperdiet ut. Nunc quis leo pharetra, lacinia erat vitae, porttitor sem. Mauris vel aliquet risus. Vestibulum mattis convallis urna, in lobortis magna sodales nec. Vestibulum mollis ex sit amet volutpat eleifend. Phasellus interdum fermentum augue. Sed malesuada ipsum vitae purus mattis elementum. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Sed aliquet varius auctor. Nulla dignissim ex eu sapien eleifend, efficitur auctor ante malesuada. Duis sed lectus in justo feugiat tristique eu sed enim.";

s1 = split(s,""); s1(1) = []; s1(numel(s1))=[]; c = unique(s1);
T = numel(s1); M = numel(c);
% rp = randperm(M); ci = c(rp); c = ci; %% Secondo me non serve
N = round(0.5*T); alpha = 0.5;
rng(12345);
[u,v] = init(N,M);
[ss,w,errh] = online_learning(u,v,c,alpha,s1,c);
plot(errh);xlabel('Passo');ylabel('Errore');
%[ss,w] = offline_learning(u,v,c,alpha,s1,ci);

function [u,v] = init(N,M)
	u = rand(N,M);
	v = eye(M);
	for i = 1:M
		u(:,i) = u(:,i)-mean(u(:,i));
		u(:,i) = u(:,i)/norm(u(:,i),'fro');
	end
end

function ss = recall(T,N,w,u,c,a,ss1,ci)
	x = zeros(N,1);	
	i = find(ci==ss1);
	ss =ss1;
	for j = 1:T-1
		x = (1.0-a)*x+a*(u(:,i)+circshift(x,1));
		x = x/norm(x,'fro');
		y = exp(w*x);
		[~,i] = max(y/sum(y));
		ss = [ss; c(i)];
    end
end

function erro = error(s,ss)
	err = 0;
	for i = 1:numel(s)
		err = err+(s(i) ~= ss(i));
	end
	erro = round(err*100/numel(s),2);
end

function [ss,w,errh] = online_learning(u,v,c,a,s,ci)
 T = numel(s);
 [N,M] = size(u);
 w = zeros(M,N);
 err = 100;
 tt = 1;
 errh = [];
while(err>0 && tt<=T)
	x = zeros(N,1);
	for i = 1:T-1
 		x = (1.0-a)*x+a*(u(:,find(ci==s(i)))+circshift(x,1));
 		x = x/norm(x,'fro');
 		p = exp(w*x);
 		p = p/sum(p,'all');
 		w = w+(v(:,find(ci==s(i+1),1))-p)*x';
    end
 	ss = recall(T,N,w,u,c,a,s(1),ci);
 	err = error(s,ss)
 	tt = tt+1;
    errh = [errh err];
 end
end

% % function [ss,w] = offline_learning(u,v,c,a,s,ci)
% %  T = numel(s);
% %  [N,M] = size(u);
% %  eta = 1e-7;
% %  X = zeros(N,T); 
% %  S = zeros(M,T);
% %  x = zeros(N,1);
% %  for i=1:T-1
% %     %x1 = (1.0-a)*x %DGN
% %     %x2 = a*(u(:,find(ci==s(i))).'+circshift(x,1))%DGN
% %  	x = (1.0-a)*x+a*(u(:,find(ci==s(i)))+circshift(x,1));
% %  	x = x/norm(x,'fro');
% %  	X(:,i) = x;
% %     S(:,i) = v(:,find(ci==s(i+1),1));    
% %  end
% %  XX = X*X.';
% %  for j = 1:N
% %  	XX(j,j) = XX(j,j)+eta;
% %  end 
% %  	w = S*X.'*inv(XX);
% %  	%[offlinew1 offlinew2] = size(w)%DGN
% %  	%[su1offline su2offline ] = size(u) %DGN
% %  	ss = recall(T,N,w,u,c,a,s(1),ci);
% %  	%n_ss = numel(ss) %DGN
% %  	"err = "
% %  	error(s,ss)
% %  	%fprintf("err = ",error(s,ss))
% % 
% % end
% % 
