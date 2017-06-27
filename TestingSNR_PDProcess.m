% 1) ADD NOISE TO RAW SIGNAL
% 2)FIND PEAK ANALYSIS

file='A3\A3.csv'; %Name of the files to be saved to
noisyfile='A3\A3-SNR-20.csv';
SNR =-20;


load A3; %(doesnt have the 'class' feature for easy processing- 270X2016)
load A32017; %(same as A3 but has the 'class' feature 270x2017)
ncols=20; %Num of cols in the final output matrix

 noisyMatrix = zeros(270,2016); %Matrix for storing the non-normalised noisy signal 
 
 StatParams=zeros(270,ncols); %Matrices for storing the output parameters (peak analysis)
 NoisyStatParams=zeros(270,ncols);

%adding noise to the raw signal and storing output in noisyMatrix
 for num_rows = 1:270
     test=A3(num_rows,1:2016);
    testNoise = awgn(test, SNR,'measured'); %add noise to the raw signal
    noisyMatrix(num_rows,1:2016)= testNoise; %normalise each row 
 end
 
 
 
% Frequency Spectrum of Raw PD signal
for num_rows = 1:270
    test=A3(num_rows,1:2016);
   
    fft_PD = fft(test,nfft,2); % fast fourier transform (fft) of PD
    fft_PD = fft_PD(1:NumUniquePts);
    fft_PD = abs(fft_PD(1:100)); % take the absolute value
 
    %TAKE THE HIGHEST 5 PEAKS FROM THE RAW SIGNAL AND GET PEAK FEATURES
    %(LOCAL MAXIMA,LOCATION,WIDTH & PROMINENCE)
   [pks,locs,w,p] = findpeaks(fft_PD(1:100),'SortStr','descend','npeaks',5);
  
     StatParams(num_rows,1:5)=pks;
     StatParams(num_rows,6:10)=locs;
     StatParams(num_rows,11:15)=w;
     StatParams(num_rows,16:20)=p; 
end

% Frequency Spectrum of Noisy PD signal 
 for num_rows = 1:270
    test=noisyMatrix(num_rows,1:2016);
   
    fft_NPD = fft(test,nfft,2); % fast fourier transform (fft) of NPD
    fft_NPD = fft_NPD(1:NumUniquePts);
    fft_NPD = abs(fft_NPD(1:100)); % take the absolute value
 
    
    %TAKE THE HIGHEST 5 PEAKS FROM THE NOISY SIGNAL GET PEAK FEATURES
    %(LOCAL MAXIMA,LOCATION,WIDTH & PROMINENCE)
    [pks,locs,w,p] = findpeaks(fft_NPD(1:100),'SortStr','descend','npeaks',5);
    
     NoisyStatParams(num_rows,1:5)=pks;
     NoisyStatParams(num_rows,6:10)=locs;
     NoisyStatParams(num_rows,11:15)=w;
     NoisyStatParams(num_rows,16:20)=p;  
 end

 %ADD THE CLASS ATTRIBUTE FROM A32017
    StatParams=[StatParams,A32017(1:270,2017)];
    NoisyStatParams=[NoisyStatParams,A32017(1:270,2017)]; 
    
csvwrite(file,StatParams);
csvwrite(noisyfile,NoisyStatParams);
  
   

    
 