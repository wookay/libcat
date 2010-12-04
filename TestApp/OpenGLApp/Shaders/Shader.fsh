//
//  Shader.fsh
//  OpenGL
//
//  Created by WooKyoung Noh on 03/12/10.
//  Copyright 2010 factorcat. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
