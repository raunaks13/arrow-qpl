% Licensed to the Apache Software Foundation (ASF) under one or more
% contributor license agreements.  See the NOTICE file distributed with
% this work for additional information regarding copyright ownership.
% The ASF licenses this file to you under the Apache License, Version
% 2.0 (the "License"); you may not use this file except in compliance
% with the License.  You may obtain a copy of the License at
%
%   http://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
% implied.  See the License for the specific language governing
% permissions and limitations under the License.
    
classdef (Abstract) Array < matlab.mixin.CustomDisplay & ...
                            matlab.mixin.Scalar
% arrow.array.Array

    properties (GetAccess=public, SetAccess=private, Hidden)
        Proxy
    end

    properties (Dependent)
        Length
        Valid % Validity bitmap
    end

    properties(Dependent, SetAccess=private, GetAccess=public)
        Type(1, 1) arrow.type.Type
    end
    
    methods
        function obj = Array(proxy)
            arguments
                proxy(1, 1) libmexclass.proxy.Proxy
            end
            obj.Proxy = proxy;
        end

        function numElements = get.Length(obj)
            numElements = obj.Proxy.getLength();
        end

        function validElements = get.Valid(obj)
            validElements = obj.Proxy.getValid();
        end

        function matlabArray = toMATLAB(obj)
            matlabArray = obj.Proxy.toMATLAB();
        end

        function type = get.Type(obj)
            typeStruct = obj.Proxy.getType();
            traits = arrow.type.traits.traits(arrow.type.ID(typeStruct.TypeID));
            proxy = libmexclass.proxy.Proxy(Name=traits.TypeProxyClassName, ID=typeStruct.ProxyID);
            type = traits.TypeConstructor(proxy);
        end
    end

    methods (Access = private)
        function str = toString(obj)
            str = obj.Proxy.toString();
        end
    end

    methods (Access=protected)
        function displayScalarObject(obj)
            disp(obj.toString());
        end
    end

    methods
        function tf = isequal(obj, varargin)
            narginchk(2, inf);
            tf = false;
            % Extract each array's proxy ID
            proxyIDs = zeros(numel(varargin), 1, "uint64");
            for ii = 1:numel(varargin)
                array = varargin{ii};
                if ~isa(array, "arrow.array.Array")
                    % Return early if array is not a arrow.array.Array
                    return;
                end
                proxyIDs(ii) = array.Proxy.ID;
            end
            % Invoke isEqual proxy object method
            tf = obj.Proxy.isEqual(proxyIDs);
        end
    end
end

