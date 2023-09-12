#include <Geode/DefaultInclude.hpp>

#ifdef GEODE_IS_MACOS

#include <Geode/cocos/platform/mac/CCEventDispatcher.h>
#include <Geode/cocos/platform/mac/EAGLView.h>
#include <Geode/Loader.hpp>
#include <Geode/Utils.hpp>

using namespace geode::prelude;

@interface TestView : NSOpenGLView {
	
}

- (id) initWithFrame:(NSRect)frameRect shareContext:(NSOpenGLContext*)context;

@end

@implementation TestView

- (id) initWithFrame:(NSRect)frameRect shareContext:(NSOpenGLContext*)context {
	
	NSOpenGLPixelFormatAttribute attribs[] =
    {
//		NSOpenGLPFAAccelerated,
//		NSOpenGLPFANoRecovery,
		NSOpenGLPFADoubleBuffer,
		NSOpenGLPFADepthSize, 24,
		NSOpenGLPFAOpenGLProfile, NSOpenGLProfileVersion4_1Core,
		0
    };

    NSOpenGLPixelFormat *pixelFormat = [[NSOpenGLPixelFormat alloc] initWithAttributes:attribs];

    if( (self = [super initWithFrame:frameRect pixelFormat:[pixelFormat autorelease]]) ) {
		
		if( context )
			[self setOpenGLContext:context];

		// event delegate
		((EAGLView*)self).eventDelegate = [NSClassFromString(@"CCEventDispatcher") sharedDispatcher];
	}
    
    cocos2d::CCEGLView::sharedOpenGLView()->setFrameSize(frameRect.size.width, frameRect.size.height);
    
    [(EAGLView*)self setFrameZoomFactor:1.0f];

    log::debug("OpenGL version = {}", (char const*)glGetString(GL_VERSION));
	log::debug("GLSL version = {}", (char const*)glGetString(GL_SHADING_LANGUAGE_VERSION));
	
	*reinterpret_cast<TestView**>(base::get() + 0x6a0b28) = self;
	return self;
}


@end

id initWithFrame(EAGLView* self, SEL selector, NSRect frameRect, NSOpenGLContext* context) {
	return [(TestView*)self initWithFrame:frameRect shareContext:context];
} 

$execute {
	if (auto res = ObjcHook::create("EAGLView", "initWithFrame:shareContext:", &initWithFrame)) {
		Mod::get()->addHook(res.unwrap());
	}
}

#endif