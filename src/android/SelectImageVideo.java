package com.dias.plugin;


import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.widget.Toast;

import com.luck.picture.lib.PictureSelectionModel;
import com.luck.picture.lib.PictureSelector;
import com.luck.picture.lib.PictureSelectorActivity;
import com.luck.picture.lib.compress.Luban;
import com.luck.picture.lib.config.PictureConfig;
import com.luck.picture.lib.config.PictureMimeType;
import com.luck.picture.lib.entity.LocalMedia;
import com.luck.picture.lib.permissions.RxPermissions;
import com.luck.picture.lib.tools.DebugUtil;
import com.luck.picture.lib.tools.PictureFileUtils;

import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.apache.cordova.CordovaWebView;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

import io.ionic.starter.R;
import io.reactivex.Observer;
import io.reactivex.disposables.Disposable;

import static android.app.Activity.RESULT_OK;

/**
 * This class echoes a string called from JavaScript.
 */
public class SelectImageVideo extends CordovaPlugin {

  public static final String WRITE = Manifest.permission.WRITE_EXTERNAL_STORAGE;

  String [] permissions = { Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.CAMERA, Manifest.permission.RECORD_AUDIO };
  public static final int REQUESTCODE = 0;
  public static final int PERMISSION_DENIED_ERROR = 20;

  private final static String TAG = "cordovatest";
  private List<LocalMedia> selectList = new ArrayList<>();
  private CallbackContext callbackContext;
  private int openGallery;
  private int selectionMode;
  private int maxSelectNum = 1;
  public int num;
  public String reAction;
  protected void getReadPermission()
  {
    cordova.requestPermissions(this, REQUESTCODE, permissions);
  }
  @Override
  public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
    this.callbackContext = callbackContext;
    this.num = args.getInt(0);
    this.reAction = action;
    if (reAction.equals("selectAll") || reAction.equals("selectImage") || reAction.equals("selectVideo") || reAction.equals("selectAllSingle") ||
            reAction.equals("selectImageSingle") || reAction.equals("selectVideoSingle")){
      if(cordova.hasPermission(WRITE)){
        select();
      }else {
        getReadPermission();
      }
      return true;
    }


    return false;
  }

  public void select(){
    if (reAction.equals("selectAll")) {
      //图片或者视频,多选
      this.maxSelectNum = num;
      this.openGallery = PictureMimeType.ofAll();
      this.selectionMode = PictureConfig.MULTIPLE;
      coolMethod();
    }else if (reAction.equals("selectImage")){
      //仅图片,多选
      this.maxSelectNum = num;
      this.openGallery = PictureMimeType.ofImage();
      this.selectionMode = PictureConfig.MULTIPLE;
      coolMethod();
    }else if (reAction.equals("selectVideo")){
      //仅视频,多选
      this.maxSelectNum = num;
      this.openGallery = PictureMimeType.ofVideo();
      this.selectionMode = PictureConfig.MULTIPLE;
      coolMethod();
    }else if (reAction.equals("selectAllSingle")){
      //图片或者视频,单选
      this.openGallery = PictureMimeType.ofAll();
      this.selectionMode = PictureConfig.SINGLE;
      coolMethod();
    }else if (reAction.equals("selectImageSingle")){
      //仅图片,单选
      this.openGallery = PictureMimeType.ofImage();
      this.selectionMode = PictureConfig.SINGLE;
      coolMethod();
    }else if (reAction.equals("selectVideoSingle")){
      //仅视频,单选
      this.openGallery = PictureMimeType.ofVideo();
      this.selectionMode = PictureConfig.SINGLE;
      coolMethod();
    }
  }

  private void coolMethod() {
    //清除缓存
    // PictureFileUtils.deleteCacheDirFile(this.cordova.getActivity());
    // 进入相册 以下是例子：不需要的api可以不写
    PictureSelector.create(this.cordova.getActivity())
      .openGallery(openGallery)// 全部.PictureMimeType.ofAll()、图片.ofImage()、视频.ofVideo()
      .maxSelectNum(maxSelectNum)// 最大图片选择数量 int
      .minSelectNum(1)// 最小选择数量 int
      .imageSpanCount(4)// 每行显示个数 int
      .selectionMode(selectionMode)// 多选 or 单选 PictureConfig.MULTIPLE or PictureConfig.SINGLE
      .previewImage(true)// 是否可预览图片 true or false
      .previewVideo(true)// 是否可预览视频 true or false
      .compressGrade(Luban.THIRD_GEAR)// luban压缩档次，默认3档 Luban.THIRD_GEAR、Luban.FIRST_GEAR、Luban.CUSTOM_GEAR
      .isCamera(true)// 是否显示拍照按钮 ture or false
      .compress(true)// 是否压缩 true or false
      .compressMode(PictureConfig.LUBAN_COMPRESS_MODE)//系统自带 or 鲁班压缩 PictureConfig.SYSTEM_COMPRESS_MODE or LUBAN_COMPRESS_MODE
      .glideOverride(200,200)// glide 加载宽高，越小图片列表越流畅，但会影响列表图片浏览的清晰度 int
      .isGif(false)// 是否显示gif图片 true or false
      .openClickSound(false)// 是否开启点击声音 true or false
      .previewEggs(true)// 预览图片时 是否增强左右滑动图片体验(图片滑动一半即可看到上一张是否选中) true or false
      .compressMaxKB(512)//压缩最大值kb compressGrade()为Luban.CUSTOM_GEAR有效 int
      .compressWH(1,1) // 压缩宽高比 compressGrade()为Luban.CUSTOM_GEAR有效 int
      .videoQuality(1)// 视频录制质量 0 or 1 int
      .videoSecond(11)//显示多少秒以内的视频 int
      .recordVideoSecond(11);//录制视频秒数 默认60s int
//        .forResult(PictureConfig.CHOOSE_REQUEST);//结果回调onActivityResult code
    Intent intent = new Intent(this.cordova.getActivity(), PictureSelectorActivity.class);
    this.cordova.startActivityForResult(this, intent, PictureConfig.CHOOSE_REQUEST);
  }

  @Override
  public void onActivityResult(int requestCode, int resultCode, Intent data) {
    super.onActivityResult(requestCode, resultCode, data);
    if (resultCode == RESULT_OK) {
      switch (requestCode) {
        case PictureConfig.CHOOSE_REQUEST:
          // 图片选择结果回调
          JSONObject jsonObject = new JSONObject();
          JSONArray pictureList = new JSONArray();
          selectList = PictureSelector.obtainMultipleResult(data);
          String type = selectList.get(0).getPictureType();
          String pictureType = "";
          int size = type.indexOf("/");
          if (type.substring(0,size).equals("image")){
            pictureType = "picture";
            for (LocalMedia path:selectList) {
              if (path.isCompressed()){
                pictureList.put(path.getCompressPath());
              }else {
                pictureList.put(path.getPath());
              }
            }
            try {
              jsonObject.put(pictureType,pictureList);
            } catch (JSONException e) {
              e.printStackTrace();
            }
          }else if (type.substring(0,size).equals("video")){
            pictureType = "video";
            for (LocalMedia path:selectList) {
              pictureList.put(path.getPath());
            }
            try {
              jsonObject.put(pictureType,pictureList);
            } catch (JSONException e) {
              e.printStackTrace();
            }
          }else {
            this.callbackContext.error("媒体类型错误");
          }
          this.callbackContext.success(jsonObject);
          break;
      }
    }
  }

  public void onRequestPermissionResult(int requestCode, String[] permissions,
                                        int[] grantResults) throws JSONException {
    for (int r : grantResults) {
      if (r == PackageManager.PERMISSION_DENIED) {
        this.callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, PERMISSION_DENIED_ERROR));
        return;
      }
    }
    if (requestCode == REQUESTCODE){
      select();
    }
  }

}
