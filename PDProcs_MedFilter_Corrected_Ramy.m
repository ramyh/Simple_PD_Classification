%FIND LOG OF FIRST 50 SAMPLING POINTS IN FFT

file='B3\B3.csv'; %Name of the files to be saved to
noisyfile='B3\B3-SNR20.csv';
SNR =20;
nrow=27; %Row num that you want to plot (optional)

 load B3;
 load B32017;
 ncols=50; %Num of cols in the final output matrix

 noisyMatrix = zeros(270,2016); %Matrix for storing the normalised noisy signal and normalised raw signal
 normB3=zeros(270,2016); 
 
 PlotPD=zeros(270,250); %Temporary matrices used for plotting
 PlotNPD=zeros(270,250);
 
 StatParams=zeros(270,ncols); %Matrices for storing the output parameters (log of the 50 values)
 NoisyStatParams=zeros(270,ncols);

n=length(normB3(nrow,1:2016)); % length of the PD signal (number of samples in time domain)
fs=500000000; % sampling rate
ts=1/fs; % time step
t_end= n/fs;
time=0:ts:t_end-ts;
time=time';

% Frequency axis
nfft = 2^(nextpow2(n));
NumUniquePts = ceil((nfft+1)/2);
freq = (0:NumUniquePts-1)*fs/nfft; % frequency index

 for num_rows = 1:270
     test=B3(num_rows,1:2016);
     test=medfilt1(test); %apply the median filter to raw signal
     normB3(num_rows,1:2016)= mapminmax(test); %normalise each row in B3 
     
 end

 testNoise = awgn(normB3, SNR,'measured'); %add noise to the raw signal
 testNoise = medfilt1(testNoise); %apply the median filter
 noisyMatrix = testNoise;
 
 
%  for num_rows = 1:270
%      test=B3(num_rows,1:2016);
%     testNoise = awgn(test, SNR,'measured'); %add noise to the raw signal
%     testNoise=medfilt1(testNoise); %apply the median filter 
%     noisyMatrix(num_rows,1:2016)= mapminmax(testNoise); %normalise each row 
%  end
 

% Frequency Spectrum of PD signal
for num_rows = 1:270
    test=normB3(num_rows,1:2016);
   
    fft_PD = fft(test,nfft,2); % fast fourier transform (fft) of PD
    fft_PD = fft_PD(1:NumUniquePts);
    fft_PD = abs(fft_PD(1:250)); % take the absolute value
 
    % PlotPD(num_rows,1:250)=fft_PD(1:250); %Vector for plotting
    
  StatParams(num_rows,1:50)=log(fft_PD(1:50)); %Find log of first 50 sampling points
   
 %find 5 statistical parameters from the normalised B3 signal
%{
     [pks,locs,w,p] = findpeaks(fft_PD(1:100),'SortStr','descend','npeaks',10);
     StatParams(num_rows,1:10)=pks;
     StatParams(num_rows,11:20)=locs;
%}
end

 for num_rows = 1:270
    test=noisyMatrix(num_rows,1:2016);
   
    fft_NPD = fft(test,nfft,2); % fast fourier transform (fft) of NPD
    fft_NPD = fft_NPD(1:NumUniquePts);
    fft_NPD = abs(fft_NPD(1:250)); % take the absolute value
    %PlotNPD(num_rows,1:250)=fft_NPD(1:250);  %Vector for plotting
    
    NoisyStatParams(num_rows,1:50)=log(fft_NPD(1:50)); %Find log of first 50 sampling points
    
    
    %find 5 statistical parameters from the noisy signal
      %{
   [pks,locs,w,p] = findpeaks(fft_NPD(1:100),'SortStr','descend','npeaks',10,'Annotate','peaks');
     NoisyStatParams(num_rows,1:10)=pks;
     NoisyStatParams(num_rows,11:20)=locs;
    %}
 end

    StatParams=[StatParams,B32017(1:270,2017)];
    NoisyStatParams=[NoisyStatParams,B32017(1:270,2017)]; 
    
	csvwrite(file,StatParams);
    csvwrite(noisyfile,NoisyStatParams);
  
    
    
 %{ 
 %PLOT FOR CHECKING RAW AND NOISY SIGNALS
 str=strcat('SNR',num2str(SNR));
 figure
 plot(1:2016,noisyMatrix(nrow,1:2016),'r');
 hold on
 plot(1:2016,normB3(nrow,1:2016),'b');
 grid on
 
%PLOT FOR CHECKING THE PEAKS IN RAW SIGNAL (FOR STATISTICAL PARAMS)
 figure
 findpeaks(PlotPD(nrow,5:250),'SortStr','descend','npeaks',10,'Annotate','extents');
 title(strcat(num2str(nrow),str))
 grid on

%PLOT FOR CHECKING THE PEAKS IN NOISY SIGNAL (FOR STATISTICAL PARAMS)
 figure
 findpeaks(PlotNPD(nrow,5:250),'SortStr','descend','npeaks',10,'Annotate','extents');
 title(strcat(num2str(nrow),str))
 grid on
%}

