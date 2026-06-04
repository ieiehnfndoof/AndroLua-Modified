package com.androlua;

import android.animation.Animator;
import android.animation.AnimatorSet;
import android.animation.ObjectAnimator;
import android.animation.ValueAnimator;
import android.view.View;
import android.view.animation.*;

/**
 * LuaAnimationHelper - Enhanced animation support for AndroLua
 * Provides GUI animations and HTML animation utilities accessible from Lua scripts
 */
public class LuaAnimationHelper {

    // ── GUI Animations ──────────────────────────────────────────────

    public static void fadeIn(View view, long duration) {
        view.setVisibility(View.VISIBLE);
        ObjectAnimator anim = ObjectAnimator.ofFloat(view, "alpha", 0f, 1f);
        anim.setDuration(duration);
        anim.start();
    }

    public static void fadeOut(View view, long duration) {
        ObjectAnimator anim = ObjectAnimator.ofFloat(view, "alpha", 1f, 0f);
        anim.setDuration(duration);
        anim.addListener(new Animator.AnimatorListener() {
            public void onAnimationStart(Animator a) {}
            public void onAnimationEnd(Animator a) { view.setVisibility(View.GONE); }
            public void onAnimationCancel(Animator a) {}
            public void onAnimationRepeat(Animator a) {}
        });
        anim.start();
    }

    public static void slideInLeft(View view, long duration) {
        view.setVisibility(View.VISIBLE);
        ObjectAnimator anim = ObjectAnimator.ofFloat(view, "translationX", -view.getWidth(), 0f);
        anim.setDuration(duration);
        anim.setInterpolator(new DecelerateInterpolator());
        anim.start();
    }

    public static void slideInRight(View view, long duration) {
        view.setVisibility(View.VISIBLE);
        ObjectAnimator anim = ObjectAnimator.ofFloat(view, "translationX", view.getWidth(), 0f);
        anim.setDuration(duration);
        anim.setInterpolator(new DecelerateInterpolator());
        anim.start();
    }

    public static void slideInTop(View view, long duration) {
        view.setVisibility(View.VISIBLE);
        ObjectAnimator anim = ObjectAnimator.ofFloat(view, "translationY", -view.getHeight(), 0f);
        anim.setDuration(duration);
        anim.setInterpolator(new DecelerateInterpolator());
        anim.start();
    }

    public static void slideInBottom(View view, long duration) {
        view.setVisibility(View.VISIBLE);
        ObjectAnimator anim = ObjectAnimator.ofFloat(view, "translationY", view.getHeight(), 0f);
        anim.setDuration(duration);
        anim.setInterpolator(new DecelerateInterpolator());
        anim.start();
    }

    public static void scaleIn(View view, long duration) {
        view.setVisibility(View.VISIBLE);
        ObjectAnimator scaleX = ObjectAnimator.ofFloat(view, "scaleX", 0f, 1f);
        ObjectAnimator scaleY = ObjectAnimator.ofFloat(view, "scaleY", 0f, 1f);
        AnimatorSet set = new AnimatorSet();
        set.playTogether(scaleX, scaleY);
        set.setDuration(duration);
        set.setInterpolator(new OvershootInterpolator());
        set.start();
    }

    public static void scaleOut(View view, long duration) {
        ObjectAnimator scaleX = ObjectAnimator.ofFloat(view, "scaleX", 1f, 0f);
        ObjectAnimator scaleY = ObjectAnimator.ofFloat(view, "scaleY", 1f, 0f);
        AnimatorSet set = new AnimatorSet();
        set.playTogether(scaleX, scaleY);
        set.setDuration(duration);
        set.addListener(new Animator.AnimatorListener() {
            public void onAnimationStart(Animator a) {}
            public void onAnimationEnd(Animator a) { view.setVisibility(View.GONE); }
            public void onAnimationCancel(Animator a) {}
            public void onAnimationRepeat(Animator a) {}
        });
        set.start();
    }

    public static void rotate(View view, float fromDeg, float toDeg, long duration) {
        ObjectAnimator anim = ObjectAnimator.ofFloat(view, "rotation", fromDeg, toDeg);
        anim.setDuration(duration);
        anim.start();
    }

    public static void rotateLoop(View view, long duration) {
        ObjectAnimator anim = ObjectAnimator.ofFloat(view, "rotation", 0f, 360f);
        anim.setDuration(duration);
        anim.setRepeatCount(ValueAnimator.INFINITE);
        anim.setInterpolator(new LinearInterpolator());
        anim.start();
    }

    public static void bounce(View view, long duration) {
        ObjectAnimator anim = ObjectAnimator.ofFloat(view, "translationY", 0f, -30f, 0f, -15f, 0f);
        anim.setDuration(duration);
        anim.setInterpolator(new AccelerateDecelerateInterpolator());
        anim.start();
    }

    public static void shake(View view, long duration) {
        ObjectAnimator anim = ObjectAnimator.ofFloat(view, "translationX", 0f, 20f, -20f, 15f, -15f, 10f, -10f, 0f);
        anim.setDuration(duration);
        anim.start();
    }

    public static void pulse(View view, long duration) {
        ObjectAnimator scaleX = ObjectAnimator.ofFloat(view, "scaleX", 1f, 1.1f, 1f);
        ObjectAnimator scaleY = ObjectAnimator.ofFloat(view, "scaleY", 1f, 1.1f, 1f);
        AnimatorSet set = new AnimatorSet();
        set.playTogether(scaleX, scaleY);
        set.setDuration(duration);
        set.setRepeatCount(ValueAnimator.INFINITE);
        set.start();
    }

    public static void flip(View view, long duration) {
        ObjectAnimator anim = ObjectAnimator.ofFloat(view, "rotationY", 0f, 360f);
        anim.setDuration(duration);
        anim.setInterpolator(new AccelerateDecelerateInterpolator());
        anim.start();
    }

    public static void moveTo(View view, float x, float y, long duration) {
        ObjectAnimator animX = ObjectAnimator.ofFloat(view, "translationX", x);
        ObjectAnimator animY = ObjectAnimator.ofFloat(view, "translationY", y);
        AnimatorSet set = new AnimatorSet();
        set.playTogether(animX, animY);
        set.setDuration(duration);
        set.setInterpolator(new DecelerateInterpolator());
        set.start();
    }

    public static void colorChange(View view, int fromColor, int toColor, long duration) {
        ValueAnimator anim = ValueAnimator.ofArgb(fromColor, toColor);
        anim.setDuration(duration);
        anim.addUpdateListener(animator -> view.setBackgroundColor((int) animator.getAnimatedValue()));
        anim.start();
    }

    // ── HTML Animation Template ──────────────────────────────────────

    /**
     * Returns an HTML template with CSS animations for use in WebView
     */
    public static String getHtmlAnimationTemplate(String content, String animationType) {
        String css = getAnimationCSS(animationType);
        return "<!DOCTYPE html><html><head><meta charset='utf-8'>" +
               "<meta name='viewport' content='width=device-width, initial-scale=1'>" +
               "<style>body{margin:0;padding:16px;font-family:sans-serif;background:#1a1a2e;color:#eee;}" +
               css + "</style></head><body>" + content + "</body></html>";
    }

    private static String getAnimationCSS(String type) {
        switch (type) {
            case "fadeIn":
                return "@keyframes fadeIn{from{opacity:0}to{opacity:1}}.animated{animation:fadeIn 1s ease forwards;}";
            case "slideUp":
                return "@keyframes slideUp{from{transform:translateY(100px);opacity:0}to{transform:translateY(0);opacity:1}}.animated{animation:slideUp 0.6s ease forwards;}";
            case "pulse":
                return "@keyframes pulse{0%,100%{transform:scale(1)}50%{transform:scale(1.05)}}.animated{animation:pulse 1s infinite;}";
            case "bounce":
                return "@keyframes bounce{0%,100%{transform:translateY(0)}50%{transform:translateY(-20px)}}.animated{animation:bounce 0.8s infinite;}";
            case "rotate":
                return "@keyframes rotate{from{transform:rotate(0deg)}to{transform:rotate(360deg)}}.animated{animation:rotate 2s linear infinite;}";
            case "rainbow":
                return "@keyframes rainbow{0%{color:#ff0000}16%{color:#ff8800}33%{color:#ffff00}50%{color:#00ff00}66%{color:#0088ff}83%{color:#8800ff}100%{color:#ff0000}}.animated{animation:rainbow 2s linear infinite;}";
            default:
                return ".animated{}";
        }
    }
}
