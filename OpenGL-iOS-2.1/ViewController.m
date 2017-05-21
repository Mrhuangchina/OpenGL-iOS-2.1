//
//  ViewController.m
//  OpenGL-iOS-2.1
//
//  Created by MrHuang on 17/5/18.
//  Copyright © 2017年 Mrhuang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    GLuint vertexBufferID;
}

@property(nonatomic,strong)GLKBaseEffect *baseEffect;

@end

@implementation ViewController

@synthesize baseEffect;

typedef struct{

    GLKVector3 positionCoords;
    
}scenVertex;

static const scenVertex vertices[] =
{
    {{-0.5f,-0.5f,0.0}}, //左下角
    {{0.5f,-0.5f,0.0}},  //右下角
    {{-0.5f,0.5f,0.0}}   //左上角

};

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GLKView *view = (GLKView *)self.view;
    
    NSAssert([view isKindOfClass:[GLKView class]],@"这个View不是GLKitViewController的View");
    
    view.context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    [EAGLContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc]init];
    
    self.baseEffect.useConstantColor = GL_TRUE;
    //用白色来渲染三角形，意味着在三角形中每一个像素都有相同的颜色值。
    self.baseEffect.constantColor = GLKVector4Make(1.0f,    //Red
                                                   1.0f,    //Green
                                                   1.0f,    //Blue
                                                   1.0f);  //Alpha
   
    //设置当前上下文的“清除颜色” 为不透明黑色，用户上下文的帧缓存被清除时候初始化每个像素的颜色值
    glClearColor(0.0f,   //Red
                 0.0f,   //Green
                 0.0f,   //Blue
                 1.0f);  //Alpha
    /* 步骤一:为缓存生成一个独一无二的标识符。
     */
    glGenBuffers(1,                 //第一个参数是生成缓存标识符的数量。
                 &vertexBufferID);  //第二个参数是一个指针 指向生成标识符的内存保存位置,
    
    /* 步骤二:为接下来的运算绑定缓存，绑定指定标识符的缓存到当前缓存
     */
    glBindBuffer(GL_ARRAY_BUFFER,   //第一个参数是常量,用于指定绑定哪一种类型的缓存 有GL_ARRAY_BUFFER和
                                    //GL_ELEMENT_ARRAY_BUFFER;其中GL_ARRAY_BUFFER用于指定一个顶点属性的数组。
                 vertexBufferID);   //
    /* 步骤三:复制数据到缓存中,复制应用的顶点数据到当前的上下文所绑定的顶点缓存中
     */

    glBufferData(GL_ARRAY_BUFFER,   //第一个参数指定要更新当前上下文中所绑定的哪一个缓存
                 sizeof(vertices),  //第二个参数指定要复制进这个缓存的字节的数量
                 vertices,          //第三个参数要复制字节的地址
                 GL_STATIC_DRAW);   //第四个参数是缓存在未来的运算中可能将会被怎样使用，其中GL_STATIC_DRAW提示会告诉上下文缓存中的内容适合复制到GPU控制的内存 因为很少修改 可以帮助OpenGL ES优化内存使用,而使用GL_DYNAMIC_DRAW提示会告诉上下文缓存中的数据会频繁改变，并提示OpenGL ES以不同的方式来处理缓存数据。
  
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    
    [self.baseEffect prepareToDraw];

    glClear(GL_COLOR_BUFFER_BIT);
    
    /*步骤四:启动，通过glEnableVertexAttribArray()来启动顶点缓存渲染操作
     */
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    
    /*步骤五:设置指针
     */
    glVertexAttribPointer(GLKVertexAttribPosition,  //第一个参数:当前绑定的缓存包含每个顶点的位置信息
                          3,                        //第二个参数:每个位置有三个部分
                          GL_FLOAT,                 //第三个参数:每个部分都保存为一个浮点值类型
                          GL_FALSE,                 //第四个参数:小数点固定数据是否被改变。
                          sizeof(scenVertex),       //第五个参数:“步幅”
                          NULL);                    //第六个参数:NULL 则说明从当前绑定的顶点魂村的开始位置访问顶点数据
    /*步骤六:绘图
     */
    glDrawArrays(GL_TRIANGLES, // 第一个参数:怎么处理顶点缓存内的顶点数据
                 0,            //第一个顶点的位置
                 3);           //渲染顶点的数量
    

    

}

-(void)viewDidUnload{
    
    GLKView *view = (GLKView *)self.view;
    [EAGLContext setCurrentContext:view.context];
    
    if (vertexBufferID != 0) {
        glDeleteBuffers(1,
                        &vertexBufferID);
        vertexBufferID = 0;
    }
    
    ((GLKView *)self.view).context = nil;
    [EAGLContext setCurrentContext:nil];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
