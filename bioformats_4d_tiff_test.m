clc;clear all;close all;
addpath('bfmatlab')

shape = [2,3,4,5,6];
% shape = [2,3,4,5];
% shape = [2,3,4];


A = reshape(1:prod(shape),shape);


fname = 'test.tif';


bfsave_volume_XYCZT(fname,A)

B = bfopen_volume_XYCZT(fname);

tmp = B~=A;
sum(tmp(:))
