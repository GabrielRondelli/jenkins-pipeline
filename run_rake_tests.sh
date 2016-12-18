#!/bin/sh


echo $(rake --rakefile ./spec/Rakefile --libdir ./spec/lib)
