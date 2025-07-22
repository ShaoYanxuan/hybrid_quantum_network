
dt =10;
maxdel = 1000;
window = 10;
start = 120;
len = 50;

gate = [start start+len]
%TAGS_nn = gated(TAGS, 2, [start start+len]);
%TAGS_n = gated(TAGS_nn, 1, [start start+len]);
[N1,N2, N12,  gg, delays] = g2_new(TAGS_P, maxdel, gate, dt, window, 1, 2, 60);
figure(42) 
plot(delays, N12./N1./N2)
title('g2')
figure(43)
plot(delays, N12/dt, 'linewidth', 2)
hold on
title('Coincedence rate')
xlabel('Time delay, us')
ylabel('Coincedence, 1/s')
% N = round(len/dt)
% %gate = [start start+len]
% for i = 1:N
%     gate = [start+dt*(i-1) start+dt*(i)];
%     %[N1(i,:),N2(i, :), N12(i, :), delays] = g2(TAGS, maxdel, gate, dt, window, 1, 2);
%     [N1{i},N2{i}, N12{i},  gg{i}, delays{i}] = g2(TAGS, maxdel, gate, dt, window, 1, 2, 60);
%     
% end;
% 
% figure(1)
% K = length(delays{N})
% M1 = zeros(K,1)';
% M12 = zeros(K,1)';
% M2 = zeros(K,1)';
% g = zeros(K+N,1)';
% gt = zeros(K+N,1)';
% 
% for i = 1:N
%    M1 = M1+N1{i}(1:K);
%    M2 = M2+N2{i}(1:K);
%    M12 = M12+N12{i}(1:K);
%    figure(1) 
%    plot(delays{i}, N12{i}./N1{i}./N2{i})
%     hold on
%     g(i:K+i-1) = g(i:K+i-1)+gg{i}(1:K);
%     
%     figure(5) 
%     gt(i:K+i-1) =gg{i}(1:K);
%     plot(delays{i},gg{i} )
%     %plot(delays{i}(1:K),gt(N:K+N-1))
%     hold on
%     title('ggi')
% end;
% figure(2)
% plot(delays{i}(1:K), N*M12./M1./M2)
% title('g2')
% figure(3)
% plot(delays{i}(1:K),g(1:K)/N )
% title('g')