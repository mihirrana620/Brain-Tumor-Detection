function varargout = tumor_detector_(varargin)
% TUMOR_DETECTOR_ MATLAB code for tumor_detector_.fig
%      TUMOR_DETECTOR_, by itself, creates a new TUMOR_DETECTOR_ or raises the existing
%      singleton*.
%
%      H = TUMOR_DETECTOR_ returns the handle to a new TUMOR_DETECTOR_ or the handle to
%      the existing singleton*.
%
%      TUMOR_DETECTOR_('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TUMOR_DETECTOR_.M with the given input arguments.
%
%      TUMOR_DETECTOR_('Property','Value',...) creates a new TUMOR_DETECTOR_ or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before tumor_detector__OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to tumor_detector__OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help tumor_detector_

% Last Modified by GUIDE v2.5 06-Aug-2021 18:34:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tumor_detector__OpeningFcn, ...
                   'gui_OutputFcn',  @tumor_detector__OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before tumor_detector_ is made visible.
function tumor_detector__OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to tumor_detector_ (see VARARGIN)

% Choose default command line output for tumor_detector_
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes tumor_detector_ wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = tumor_detector__OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in load_image.
function load_image_Callback(hObject, eventdata, handles)
% hObject    handle to load_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global im im2
[path,user_cancel] = imgetfile();
if user_cancel
    msgbox(sprintf('Invalid Selection'),'Error','Warn');
    return
end
im = imread(path);
im = im2double(im);
im2 = im;
axes(handles.axes1);
imshow(im)
title('\fontsize{18}\color[rgb]{0.635,0.078,0.184} Image of Patients''s Brain')

% --- Executes on button press in detect.
function detect_Callback(hObject, eventdata, handles)
% hObject    handle to detect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im

axes(handles.axes2);



%converting image to black and white
bw = imbinarize(im,0.7);

%focusing on the region where tumor is present
label = bwlabel(bw);

stats = regionprops(label,'Solidity','Area');  %the solidity of tumor is much higher than brain 
density = [stats.Solidity];
area = [stats.Area];

high_dense_area = density > 0.5;  %here we detect region  which has high solidity i.e more than 50%
max_area = max(area(high_dense_area));
tumor_label = find(area == max_area);
tumor = ismember(label,tumor_label);

se = strel('square',5);
tumor = imdilate(tumor,se); %here we use dilation to check the tumor is completely filled with white region


[B,L] = bwboundaries(tumor,'noholes');

imshow(im,[])
hold on
for i = 1:length(B)
    plot(B{i}(:,2),B{i}(:,1),'Y','linewidth',2.45) %this is used to mark the region where tumoris present
end
title('Detected Tumors')
hold off


