package com.jni.systeminfo;

import android.util.Log;

import jcifs.smb.NtlmPasswordAuthentication;
import jcifs.smb.SmbFile;
import jcifs.smb.SmbFileOutputStream;

import java.util.Arrays;
import java.util.List;


public class NetworkManager
{
   public static boolean downloadFile(String usrname,String pass,String ip_address,String filePath,String outStream) {

     //  Log.i("MySimple", usrname);

         try {

                 NtlmPasswordAuthentication authentication = new NtlmPasswordAuthentication(
                         null, usrname, pass);
                 SmbFile home = new SmbFile("smb://"+ip_address+"/"+filePath, authentication);
                 if (!home.exists())
                   home.createNewFile();
                 if(home.canWrite() == true)
                 {
                     //java.nio.channels.FileLock lock = sfos.getChannel().lock();

                     SmbFileOutputStream sfos = new SmbFileOutputStream(home);
                     sfos.write(outStream.getBytes());
                     sfos.close();



    //                 if(home.isDirectory()) {
    //                     List<SmbFile> files = Arrays.asList(home.listFiles());
    //                     for(SmbFile file: files) {
    //                         if(file.isDirectory()) { }
    //                         if(file.isFile()) {
    //                             if(new String(file.getName()).equals("new.txt"))
    //                                { }
    //                         }
    //                     }
    //                 }
                     return true;
                }
              else
               {
                  return false;
               }
             } catch (Exception e) {
                 e.printStackTrace();
                 return false;
            }

   }

}


