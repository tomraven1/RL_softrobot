% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Copyright (C) OMG Plc 2009.
% All rights reserved.  This software is protected by copyright
% law and international treaties.  No part of this software / document
% may be reproduced or distributed in any form or by any means,
% whether transiently or incidentally to some other use of this software,
% without the written permission of the copyright owner.
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part of the ViconDataStream SDK for MATLAB.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef ServerOrientation
  properties (Constant = true)
    Unknown = 0;
    YUp     = 1;
    ZUp     = 2;
  end% properties
  
  properties
    Value
  end
  
  methods
    function obj = ServerOrientation( value )
      obj.Value = value;
    end% Constructor
    
    function String = ToString( obj )
      switch obj.Value 
        case ServerOrientation.Unknown
          String = 'Unknown';
        case ServerOrientation.YUp
          String = 'YUp';
        case ServerOrientation.ZUp
          String = 'ZUp';
        otherwise
          String = 'Unknown';
      end    
    end    
  end% methods

end% classdef
