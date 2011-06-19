package com.videobox.sample;

import java.util.ArrayList;
import java.util.List;

import org.directwebremoting.annotations.RemoteMethod;
import org.directwebremoting.annotations.RemoteProxy;

@RemoteProxy
public class SampleRemoteClass {

    @RemoteMethod
    public List<Long> fetchMyList(){
        List<Long> fakeList = new ArrayList<Long>(5);
        fakeList.add(10001L);
        fakeList.add(10011L);
        fakeList.add(10021L);
        fakeList.add(10031L);
        fakeList.add(10041L);
        
        return fakeList;
    }
}
