%{

Chien-Jung Chiu
Last Updata:2024/8/1
%}
clc; close all; clear all;

input_dir='20240731';
target_name='p1_';
%fiber_index = [1 3 5 7 9 11];
%save(target_name,'imageData')
cd(input_dir)
%for i = 1:length(fiber_index)
figure;

data1 = load([target_name '1']);
[M,~] = max(data1.imageData(:));
[row(1),col(1)] = find(data1.imageData==M);
plot(data1.imageData(:,col(1)))
    
%end
hold on;
data3 = load([target_name '3']);
[M,I] = max(data3.imageData(:));
[row(2),col(2)] = find(data3.imageData==M);
plot(data3.imageData(:,col(2)))

hold on;
data5 = load([target_name '5']);
[M,~] = max(data5.imageData(:));
[row(3),col(3)] = find(data5.imageData==M);
plot(data5.imageData(:,col(3)))

hold on;
data7 = load([target_name '7']);
[M,~] = max(data7.imageData(:));
[row(4),col(4)] = find(data7.imageData==M);
plot(data7.imageData(:,col(4)))

hold on;
data9 = load([target_name '9']);
[M,~] = max(data9.imageData(:));
[row(5),col(5)] = find(data9.imageData==M);
plot(data9.imageData(:,col(5)))

hold on;
data11 = load([target_name '11']);
[M,~] = max(data11.imageData(:));
[row(6),col(6)] = find(data11.imageData==M);
plot(data11.imageData(:,col(6)))
    
    

legend('1','3','5','7','9','11')
