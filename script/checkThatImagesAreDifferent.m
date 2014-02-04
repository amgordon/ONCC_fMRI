function [  ] = checkThatImagesAreDifferent()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

d = dir('scene*.jpg');
for i=1:length(d)
   v_h = imread(d(i).name);
   v(i,:) = reshape(v_h(201:210,201:210,:),300,1);
end

w = nan(size(v,1),size(v,1));
for i=1:size(v,1)
    for j = (i+1):size(v,1)
        
        w(i,j) = all(v(i,:)==v(j,:));
    end
end

