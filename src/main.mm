#include <Geode/DefaultInclude.hpp>

#ifdef GEODE_IS_MACOS

#include <Geode/cocos/platform/mac/CCEventDispatcher.h>
#include <Geode/cocos/platform/mac/EAGLView.h>
#include <Geode/Loader.hpp>
#include <Geode/Utils.hpp>

using namespace geode::prelude;

id initWithFrame(EAGLView* self, SEL selector, NSRect frameRect, NSOpenGLContext* context) {
	
	NSOpenGLPixelFormatAttribute attribs[] =
    {
//		NSOpenGLPFAAccelerated,
//		NSOpenGLPFANoRecovery,
		NSOpenGLPFADoubleBuffer,
		NSOpenGLPFADepthSize, 24,
		(NSOpenGLPixelFormatAttribute)NSOpenGLProfileVersion3_2Core,
		0
    };

    NSOpenGLPixelFormat *pixelFormat = [[NSOpenGLPixelFormat alloc] initWithAttributes:attribs];

    if( (self = [(NSOpenGLView*)self initWithFrame:frameRect pixelFormat:[pixelFormat autorelease]]) ) {
		
		if( context )
			[self setOpenGLContext:context];

		// event delegate
		self.eventDelegate = [CCEventDispatcher sharedDispatcher];
	}
    
    cocos2d::CCEGLView::sharedOpenGLView()->setFrameSize(frameRect.size.width, frameRect.size.height);
    
    [self setFrameZoomFactor:1.0f];
	
	*reinterpret_cast<EAGLView**>(base::get() + 0x6a0b28) = self;
	return self;
}

$execute {
	if (auto res = ObjcHook::create("EAGLView", "initWithFrame:shareContext:", &initWithFrame)) {
		Mod::get()->addHook(res.unwrap());
	}
}

#endif