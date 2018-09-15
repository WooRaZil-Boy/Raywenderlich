//
//  GameViewController.swift
//  Breaker
//
//  Created by 근성가이 on 2018. 9. 14..
//  Copyright © 2018년 근성가이. All rights reserved.
//

import UIKit
import SceneKit

class GameViewController: UIViewController {
    var scnView: SCNView! //SCNView는 SCNScene의 내용을 scene에 표시한다.
    var scnScene: SCNScene! //SCNScene 클래스는 scene를 나타낸다. SCNView의 인스턴스에 scene를 표시한다.
    //scene에 필요한, 조명, 카메라, 기하 도형, 입자 emitter 등을 이 scene의 자식으로 사용한다.
    var game = GameHelper.sharedInstance
    
    var horizontalCameraNode: SCNNode! //수평 카메라
    var verticalCameraNode: SCNNode! //수직 카메라
    
    var ballNode: SCNNode! //볼
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScene()
        setupNodes()
        setupSounds()
    }
    
    override var shouldAutorotate: Bool { //디바이스의 회전 여부 처리
        return true
    }
    
    override var prefersStatusBarHidden: Bool { //상태 표시줄 표시 여부
        return true
    }
    
    func setupScene() {
        scnView = self.view as! SCNView //self.view를 SCNView로 캐스팅해서 scnView 속성에 저장한다.
        //뷰를 참조해야 할 때마다 다시 캐스팅할 필요 없어진다. self.view 는 Main.storyboard에서 SCNView로 되어 있다.
        //SCNView는 UIView(macOS에서는 NSView)의 하위 클래스이다.
        
        scnView.delegate = self //delegate 설정
        
        scnScene = SCNScene(named: "Breaker.scnassets/Scenes/Game.scn") //scn file로 scene 초기화
        scnView.scene = scnScene //scnView에서 사용할 scene 설정
    }
    
    func setupNodes() {
        scnScene.rootNode.addChildNode(game.hudNode) //HUD 노드를 root node 에 추가한다.
        
        horizontalCameraNode = scnScene.rootNode.childNode(withName: "HorizontalCamera", recursively: true)!
        verticalCameraNode = scnScene.rootNode.childNode(withName: "VerticalCamera", recursively: true)!
        //카메라 노드들을 root node 에 추가한다.
        //scene 노드가 이미 로드되어 있으므로, rootNode.childNode 를 사용해 name으로 쉽게 가져올 수 있다.
        //recursively 매개 변수를 true로 하면 노드의 전체 하위 트리를 검색해서 해당 노드를 찾는다.
        //false일 시에는 직접적인 하위 노드만을 검색한다.
        
        ballNode = scnScene.rootNode.childNode(withName: "Ball", recursively: true)!
        //볼 노드를 root node 에 추가한다.
    }
    
    func setupSounds() {
        
    }
}

extension GameViewController: SCNSceneRendererDelegate {
    //SceneKit은 SCNView 객체를 사용해 scene의 내용을 렌더링 한다. SCNView 에 SCNSceneRendererDelegate 프로토콜을 구현 하면,
    //SCNView는 애니메이션 이벤트가 발생하고 각 프레임의 렌더링 프로세스가 진행될 때 해당 delegate 대한 메서드를 호출한다.
    //이런 식으로 SceneKit이 scene의 각 프레임을 렌더링 할 때 각 step을 거치게 된다. 이 step 들이 반복되는 loop를 구성한다.
    //render loop의 step은 다음과 같다. p.72
    //1. Update : view가 delegate의 renderer(_: updateAtTime:)를 호출한다. 기본적인 scene 업데이트 로직을 진행한다.
    //2. Execute Actions & Animations : SceneKit이 모든 액션을 실행하고 scene graph 노드에 attach된 모든 애니메이션을 실행한다.
    //3. Did Apply Animations : delegate의 renderer(_: didApplyAnimationsAtTime:)를 호출한다.
    //  이 시점에서 scene의 모든 노드들은 적용된 액션과 애니메이션을 기반으로 단일 프레임 애니메이션을 완성한다.
    //4. Simulates Physics : SceneKit은 scene의 모든 physics body에 물리 시뮬레이션의 single step을 적용한다.
    //5. Did Simulate Physics : delegate의 renderer(_: didSimulatePhysicsAtTime:)를 호출한다.
    //  이 시점에서 물리 시뮬레이션 step이 완료되며, 물리에 대한 논리를 추가할 수 있다.
    //6. Evaluates Constraints : SceneKit은 제약 조건을 평가하고 적용한다.
    //  제약조건은 SceneKit 에서 노드의 transformation을 자동으로 조정하도록 하는 규칙이다.
    //7. Will Render Scene : delegate의 renderer(_: willRenderScene: atTime:)를 호출한다.
    //  이 시점에서 view는 scene의 렌더링 정보를 가져오기 때문에 변경할 수 있는 마지막 지점이 된다.
    //8. Renders Scene In View : SceneKit가 view의 scene를 렌더링한다.
    //9. Did Render Scene : delegate의 renderer(_: didRenderScene: atTime:)를 호출한다. 렌더 루프의 한 사이클이 끝이 나는 곳으로
    //  이곳에 게임의 로직을 넣을 수 있다. 이 게임 로직은 프로세스가 새로 시작하기 전에 실행해야 한다.
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        //SceneKit의 렌더링 루프의 첫 시작이 된다. 액션, 애니메이션, 물리 법칙이 적용 되기 전에 해야하는 모든 업데이트를 수행한다.
        //SCNView 객체(혹은 SCNSceneRenderer)가 일시 중지되지 않는 한 한 프레임 당 한 번씩 이 메서드를 호출한다.
        //이 메서드를 구현해 게임 논리를 렌더링 루프에 추가한다. 이 메서드에서 scene graph를 변경하면 scene에 즉시 반영된다.
        
        game.updateHUD() //매 프레임마다 HUD를 업데이트 한다.
        //이 HUD 노드는 editor가 아닌 코드로 추가했기 때문에, 런타임 중에 scene를 생성한다. 따라서 edotor 에서는 확인할 수 없다.
    }
}

//SceneKit editor
//Xcode에서 SceneKit 게임 개발을 위해 몇 가지 새로운 도구를 만들었고, SceneKit scene editor는 그 중 하나이다.
//Xcode 6 에서 SpriteKit built-in scene editor를 도입했고, Xcode 7에서는 SceneKit built-in scene editor를 도입했다.
//SpriteKit scene editor를 사용하여 2D SpriteKit 게임을 시각적으로 디자인하고 SceneKit scene editor를 사용하여 3D SceneKit 게임을 디자인 할 수 있다.
//두 편집자의 목적은 WYSIWYG (what-you-see-that-you-get) 환경을 제공해 결과를 시각화하는 것이다.
//scene editor는 Xcode에서 scene의 애니메이션 및 물리 시뮬레이션을 재생할 수 있다. 따라서 최종 결과를 보다 정확하게 묘사 한다.
//이전 장에서는 코드로 scene 를 만들었지만, SceneKit editor로 scene file를 생성해 scene 을 만들 수도 있다.

//Adding a SceneKit scene
//Breaker.scnassets의 하위 폴더에서 모든 scene을 관리해 주는 것이 좋다.
//New File - iOS/Resource/SceneKit Scene File 로 scene template 파일을 만들 수 있다.
//생성 시, Group을 Breaker.scnassets의 하위 폴더로 지정해 준다.
//에디터에 대한 설명은 p.110




//The floor node
//floor node 는 모든 방향으로 무한대로 펼칠 수 있는 평면으로 바닥으로 주로 사용된다. 하지만 반사되는 표면이나, 호수 등 다양하게 활용할 수 있다. p.119
//Identity의 name에서 코드로 지정해 준 것과 같은 name 을 지정해 줄 수 있다.
//floor node 를 만들어도, 색이 없다면 볼 수 없다. Material을 설정해 줘야 한다.

//Adding a sphere node
//sphere와 geosphere 의 차이는 geodesic 체크박스에 있다. sphere의 polygon mesh 가 사각형이지만, geosphere는 삼각형이다. p.139
//구는 작은 폴리곤들이 결합한 구조이다. 따라서 Segment의 수가 많을 수록 구체가 부드럽지만, 렌더링에 부하가 걸린다.




//Cameras
//카메라 객체를 여러 개 만들 수 있지만, 한 번에 하나의 카메라만 scene의 활성 시점으로 사용할 수 있다.
//SceneKit은 원근법(perspective)과 직교(orthographic)의 두 가지 유형의 카메라를 제공합니다.

//Perspective camera
//원근 카메라는 1인칭 슈팅 게임(first-person shooter)와 같은 3D 게임에서 일반적으로 사용된다.
//원근법을 적용해 멀리 있는 물체가 가까운 물체보다 작게 보이도록 한다. p.122

//Orthographic Camera
//Crossy Road, Pacman256 과 같은 게임의 카메라로, 카메라에서 멀리 떨어져 있는 물체와 멀리 떨어져 있는 물체 모두 같은 크기로 보이게 한다. p.124




//Camera visual effects
//shader effects 를 SceneKit의 카메라에 추가해 줄 수 있다.

//HDR effects
//HDR (High Dynamic Range)는 게임에 사용되는 넓은 범위의 색을 표현할 수 있게 해준다.
//카메라 노드의 Attributes Inspector에는 HDR 섹션이 있다.

//Depth of field effects
//초점 거리와 크기를 제어해 depth 기반으로 블러 효과를 내도록 조리개를 조절한다. 흐리게 할 수록 더 사실적이지만, 리소스를 많이 사용한다.

//Post-processing effects
//렌더링 된 이후 scene의 결과를 효과적으로 제어한다.

//Motion blur effects
//모션 블러 효과(모든 객체에 블러 효과를 적용한다)를 낸다.




extension GameViewController {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        //view의 사이즈가 변경되는 것을 container에 알려준다. UIKit은 View Controller의 view 크기를 변경하기 전에 이 메서드를 호출한다.
        let deviceOrientation = UIDevice.current.orientation //디바이스의 현재 방향을 가져온다.
        
        switch deviceOrientation {
        case .portrait:
            scnView.pointOfView = verticalCameraNode
            //렌더링을 위한 view의 시점을 지정한다.
            //SCNCamera 인스턴스 노드를 연결해 카메라에 position(위치)와 direction(방향)을 제공해 주고,
            //카메라 객체는 view(시야), focus(초점)를 제공해 준다.
        default:
            scnView.pointOfView = horizontalCameraNode
        }
    }
    
    //Device orientation
    //디바이스가 회전하면, scene의 asset 들도 방향이 변경된다. 여기에는 카메라 노드가 2개 있으므로, 디바이스의 방향에 알맞은 카메라를 사용하도록 한다. p.133
    //하나의 카메라만 사용하도록 할 수 있지만(Sweet-spot) scene의 일부가 가려 보이지 않을 수 있다.
}




//Lights
//조명에 영향을 주는 요소는 Color(색), Direction(방향), Position(위치) 이다.
//SceneKit은 광원이 따로 추가되지 않아도 일정한 광원을 사용하긴 한다.

//Surface normal
//Surface normal는 폴리곤 표면에 수직인 가상의 벡터(또는 선) 으로 생각할 수 있다.
//3D 에서 조명으로 사용될 뿐 아니라, 폴리곤이 카메라를 향해 있는지 여부를 결정하는 데 사용하는 중요한 벡터이다. p.137
//Light source vector와 Normal vector의 각이 작을 수록 표면이 밝아지고, 클수록 어두워 진다.
//Light 오브젝트는 여러 가지가 있다.
// • Omni light : 태양의 빛을 생각하면 된다. 모든 방향으로 빛을 방출한다. ex. 촛불, 전구 (오히려 태양을 모방할 때는 적합하지 않다)
// • Directional light : 특정 방향으로 평행한 빛을 방출한다. ex. 태양
// • Spot light : 단일 지점에서 특정 방향으로 빛을 방출하지만, 원추형으로 빛이 퍼진다. ex. 손전등, 헬리콥터에의 라이트
// • Ambient light : scene의 전체적인 밝기를 제어한다. 어두운 부분의 어두움 정도를 제어할 수 있다.
// • IES light : 광도계 광원. 조명의 모양, 방향 강도를 정의한다. Illuminating Engineering Society (IES)에서 정의한 표준 형식 파일을 사용한다.
//  조명의 유형을 SCNLightTypeIES 을 사용하며, IES 파일에 대한 URL로 가져온다.
// • Light Probe : 실제 광원은 아니지만, scene에 배치해 가능한 모든 방향에서 한 지점으로 조명의 색상과 강도를 샘플링한다.
//  scene의 위치에 따라 material에 음영을 적용하는 데 사용된다.
//  ex. 흰색 물체를 밝은 색상의 벽에 가깝게 배치하면, 일반적으로 가까운 벽의 색상이 벽에 접한 표면에 반영된다.
//  일반적으로 SCNLight 속성은 광원을 생성하지 않으므로 Light Probe에 적용되지 않는다.
//  전체적인 scene에 Light Probe를 배치하여 렌더링 중에 Probe 조명 정보를 사용한다.

//Three-point lighting
//3D 그래픽을 현실감 있게 만드는 비결 중 하나는 실제 조명 기술을 사용하는 것이다. Three-point lighting은 사진 촬영에서 흔히 사용되는 효과적인 조명 기술이다.
//3개의 조명을 사용해 설정에 따라 끄거나 키면서 피사체를 비춘다. p.144
//조명의 각도를 조정하여 객체에 그림자를 추가하고 제어할 수 있다.
// • Key light : 피사체 정면에서 비추는 기본 광원
// • Back light : 피사체 뒤의 조명이며, Key light 의 반대쪽에 위치한다. 피사체의 가장자리를 강조하는 테두리 효과를 만든다.
// • Fill light : Key light의 수직 방향에 위치하며, 피사체의 어두움 정도를 제어한다.
//광원 추가에 대한 속성은 p.145 Three-point lighting 에서 각 조명이 어떻게 작동하는 지는 p.149 참고












