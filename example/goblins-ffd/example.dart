import 'dart:async';
import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';
import 'package:stagexl_spine/stagexl_spine.dart';

Future main() async {

  // configure StageXL default options

  StageXL.stageOptions.renderEngine = RenderEngine.WebGL;
  StageXL.stageOptions.backgroundColor = Color.DarkSlateGray;

  // init Stage and RenderLoop

  var canvas = html.querySelector('#stage');
  var stage = new Stage(canvas, width: 480, height: 600);
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  // load "goblins-ffd" skeleton resources

  var resourceManager = new ResourceManager();
  var libgdx = TextureAtlasFormat.LIBGDX;
  resourceManager.addTextFile("goblins", "spine/goblins-mesh.json");
  resourceManager.addTextureAtlas("goblins", "spine/goblins-mesh.atlas", libgdx);
  await resourceManager.load();

  // load Spine skeleton

  var spineJson = resourceManager.getTextFile("goblins");
  var textureAtlas = resourceManager.getTextureAtlas("goblins");
  var attachmentLoader = new TextureAtlasAttachmentLoader(textureAtlas);
  var skeletonLoader = new SkeletonLoader(attachmentLoader);
  var skeletonData = skeletonLoader.readSkeletonData(spineJson);
  var animationStateData = new AnimationStateData(skeletonData);

  // create the display object showing the skeleton animation

  var skeletonAnimation = new SkeletonAnimation(skeletonData, animationStateData);
  skeletonAnimation.x = 240;
  skeletonAnimation.y = 560;
  skeletonAnimation.scaleX = skeletonAnimation.scaleY = 1.5;
  skeletonAnimation.state.setAnimationByName(0, "walk", true);
  skeletonAnimation.skeleton.skinName = "goblin";
  stage.addChild(skeletonAnimation);
  stage.juggler.add(skeletonAnimation);

  // feature: change the skin used for the skeleton

  //skeletonAnimation.skeleton.skinName = "goblin";
  //skeletonAnimation.skeleton.skinName = "goblingirl";

  // feature: change the attachments assigned to slots

  //skeletonAnimation.skeleton.setAttachment("left hand item", "dagger");
  //skeletonAnimation.skeleton.setAttachment("right hand item", null);
  //skeletonAnimation.skeleton.setAttachment("right hand item 2", null);

}
