package com.videobox.sample2;

import java.util.ArrayList;
import java.util.List;

import org.directwebremoting.annotations.RemoteMethod;
import org.directwebremoting.annotations.RemoteProxy;

@RemoteProxy
public class SampleRemoteClass2 {

    @RemoteMethod
    public List<Long> fetchMyList(){
        List<Long> fakeList = new ArrayList<Long>(5);
        fakeList.add(20001L);
        fakeList.add(20011L);
        fakeList.add(20021L);
        fakeList.add(20031L);
        fakeList.add(20041L);
        
        return fakeList;
    }
}
