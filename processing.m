%% resampling to 100 Hz and fixing missing markers
for i=1:length(Pos)
    for j=1:3
    if (Pos(:,j,i))==0
        Pos(:,j,i)=NaN;
    end
    
    end
end

for i=1:3
[Posi(:,:,i),yt]=resample(squeeze(Pos(:,i,:))',tim(1,1:end-1),100,'spline');
end



