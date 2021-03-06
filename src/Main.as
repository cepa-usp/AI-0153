﻿package  
{
	import fl.controls.Slider;
	import cepa.utils.ToolTip;
	import fl.transitions.easing.None;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import flash.display.DisplayObject;
	import flash.filters.GlowFilter;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.Timer;
	import pipwerks.SCORM;
	/**
	 * ...
	 * @author Luciano
	 */
	public class Main extends MovieClip
	{
		private var dragging:MovieClip;
		private var alvo:MovieClip;
		private var tweenX:Tween;
		private var tweenY:Tween;
		private var tweenCultura:Tween;
		private const GLOW_FILTER:GlowFilter = new GlowFilter(0xFF0000, 1, 5, 5, 2, 2);
		private var semente1A:Number;
		private var semente1B:Number;
		private var semente2A:Number;
		private var semente2B:Number;
		private var planta:Dictionary = new Dictionary();
		private var hormonioA:Dictionary = new Dictionary();
		private var hormonioB:Dictionary = new Dictionary();
		private var textField:Dictionary = new Dictionary();
		private var cultura:Dictionary = new Dictionary();
		private var vidro:Dictionary = new Dictionary();
		private var semente:Dictionary = new Dictionary();
		private var startPoint:Dictionary = new Dictionary();
		private var botao:Dictionary = new Dictionary();
		private var slider:Dictionary = new Dictionary();
		private var explante1:Dictionary = new Dictionary();
		private var explante2:Dictionary = new Dictionary();
		private var fa1:int;
		private var fb1:int;
		private var fa2:int;
		private var fb2:int;
		private var raizUm:MovieClip = new MovieClip();
		private var raizDois:MovieClip = new MovieClip();
		private var cauleUm:MovieClip = new MovieClip();
		private var cauleDois:MovieClip = new MovieClip();
		private var xTarget:Number;
		private var lastX:Number;
		private var qualCultura:Object;
		private var qualPlanta:Array = new Array();
		private var tweenPlanta1:Tween;
		private var tweenPlanta2:Tween;
		private var explanteUm:MovieClip = new MovieClip();
		private var explanteDois:MovieClip = new MovieClip();
		private var tweenExplante:Tween;
		private var qualExplante:MovieClip;
		
		public function Main() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			this.scrollRect = new Rectangle(0, 0, 700, 700);
			
			removeChild(caule1);
			removeChild(caule2);
			removeChild(raiz1);
			removeChild(raiz2);
			removeChild(explante1Morrendo);
			removeChild(explante2Morrendo);
			removeChild(explante1Bolinha);
			removeChild(explante2Bolinha);
			
			semente1.addEventListener(MouseEvent.MOUSE_DOWN, drag);
			semente2.addEventListener(MouseEvent.MOUSE_DOWN, drag);
			slider1A.addEventListener(Event.CHANGE, changeSlider);
			slider1B.addEventListener(Event.CHANGE, changeSlider);
			slider2A.addEventListener(Event.CHANGE, changeSlider);
			slider2B.addEventListener(Event.CHANGE, changeSlider);
			trocar1.addEventListener(MouseEvent.CLICK, resetCultura);
			trocar2.addEventListener(MouseEvent.CLICK, resetCultura);
			
			menu.resetBtn.addEventListener(MouseEvent.CLICK, reset);
			menu.tutorialBtn.addEventListener(MouseEvent.CLICK, iniciaTutorial);
			menu.instructionsBtn.addEventListener(MouseEvent.CLICK, function () { infoScreen.visible = true; setChildIndex(infoScreen, numChildren - 1); } );
			infoScreen.addEventListener(MouseEvent.CLICK, function () { infoScreen.visible = false; } );
			stage.addEventListener(KeyboardEvent.KEY_DOWN, function (e:KeyboardEvent) { if (KeyboardEvent(e).keyCode == Keyboard.ESCAPE) infoScreen.visible = false; aboutScreen.visible = false;} );
			menu.creditosBtn.addEventListener(MouseEvent.CLICK, function () { aboutScreen.visible = true; setChildIndex(aboutScreen, numChildren - 1); } );
			aboutScreen.addEventListener(MouseEvent.CLICK, function () { aboutScreen.visible = false; } );
			
			makeoverOut(menu.tutorialBtn);
			makeoverOut(menu.instructionsBtn);
			makeoverOut(menu.creditosBtn);
			makeoverOut(menu.resetBtn);
			
			menu.tutorialBtn.buttonMode = true;
			menu.instructionsBtn.buttonMode = true;
			menu.resetBtn.buttonMode = true;
			menu.creditosBtn.buttonMode = true;
			trocar1.buttonMode = true;
			trocar2.buttonMode = true;
			trocar1.mouseEnabled = false;
			trocar2.mouseEnabled = false;
			trocar1.alpha = 0.4;
			trocar2.alpha = 0.4;
			semente1.buttonMode = true;
			semente2.buttonMode = true;
			
			slider1A.buttonMode = true;
			slider1A.minimum = 0;
			slider1A.maximum = 1;
			slider1A.snapInterval = 0.01;
			slider1B.buttonMode = true;
			slider1B.minimum = 0;
			slider1B.maximum = 1;
			slider1B.snapInterval = 0.01;
			slider2A.buttonMode = true;
			slider2A.minimum = 0;
			slider2A.maximum = 1;
			slider2A.snapInterval = 0.01;
			slider2B.buttonMode = true;
			slider2B.minimum = 0;
			slider2B.maximum = 1;
			slider2B.snapInterval = 0.01;
			
			// Dictionaries
			planta[cultura1] = [raizUm, cauleUm];
			planta[cultura2] = [raizDois, cauleDois];
			hormonioA[cultura1] = semente1A;
			hormonioB[cultura1] = semente1B;
			hormonioA[cultura2] = semente2A;
			hormonioB[cultura2] = semente2B;
			textField[slider1A] = textField1A;
			textField[slider1B] = textField1B;
			textField[slider2A] = textField2A;
			textField[slider2B] = textField2B;
			cultura[semente1] = [caule1, raiz1];
			cultura[semente2] = [caule2, raiz2];
			explante1[semente1] = [explante1Bolinha, explante1Morrendo];
			explante1[semente2] = [explante2Bolinha, explante2Morrendo];
			explante2[semente1] = [explante1Bolinha, explante1Morrendo];
			explante2[semente2] = [explante2Bolinha, explante2Morrendo];
			vidro[trocar1] = cultura1;
			vidro[trocar2] = cultura2;
			semente[caule1] = semente1;
			semente[caule2] = semente2;
			startPoint[semente1] = new Point(semente1.x, semente1.y);
			startPoint[semente2] = new Point(semente2.x, semente2.y);
			botao[trocar1] = cultura1;
			botao[trocar2] = cultura2;
			slider[trocar1] = [slider1A, slider1B];
			slider[trocar2] = [slider2A, slider2B];
			
			slider1A.liveDragging = true;
			slider1B.liveDragging = true;
			slider2A.liveDragging = true;
			slider2B.liveDragging = true;
			
			var ttinfo:ToolTip = new ToolTip(menu.instructionsBtn, "Orientações", 11, 0.8, 200, 0.6, 0.1);
			addChild(ttinfo);
			var ttreset:ToolTip = new ToolTip(menu.resetBtn, "Reiniciar", 11, 0.8, 200, 0.6, 0.1);
			addChild(ttreset);
			var ttcc:ToolTip = new ToolTip(menu.creditosBtn, "Créditos", 11, 0.8, 200, 0.6, 0.1);
			addChild(ttcc);
			var ttt1:ToolTip = new ToolTip(trocar1, "Trocar recipiente", 11, 0.8, 200, 0.6, 0.1);
			addChild(ttt1);
			var ttt2:ToolTip = new ToolTip(trocar2, "Trocar recipiente", 11, 0.8, 200, 0.6, 0.1);
			addChild(ttt2);
			
			//feedbackCerto.botaoOK.buttonMode = true;
			//feedbackErrado.botaoOK.buttonMode = true;
			
			infoScreen.visible = false;
			aboutScreen.visible = false;
			
			semente1A = Math.random();
			semente1B = Math.random();
			semente2A = Math.random();
			semente2B = Math.random();
			
			iniciaTutorial();
		}
		
		private function resetCultura(e:MouseEvent):void 
		{
			if (vidro[e.target].name == "cultura1") {
				xTarget = -200;
				qualExplante = explanteUm;
				tweenExplante = new Tween(explanteUm, "x", None.easeNone, explanteUm.x, xTarget, 0.4, true);
			} else if (vidro[e.target].name == "cultura2") {
				xTarget = 900;
				qualExplante = explanteDois;
				tweenExplante = new Tween(explanteDois, "x", None.easeNone, explanteDois.x, xTarget, 0.4, true);
			}
			
			if (!stage.contains(qualExplante)) {
				qualPlanta[0] = planta[botao[e.target]][0];
				qualPlanta[1] = planta[botao[e.target]][1];
				tweenPlanta1 = new Tween(qualPlanta[0], "x", None.easeNone, qualPlanta[0].x, xTarget, 0.4, true);
				tweenPlanta2 = new Tween(qualPlanta[1], "x", None.easeNone, qualPlanta[1].x, xTarget, 0.4, true);
			}
			
			e.target.mouseEnabled = false;
			e.target.alpha = 0.4;
			vidro[e.target].enabled = true;
			lastX = vidro[e.target].x;
			qualCultura = vidro[e.target];
			tweenCultura = new Tween(vidro[e.target], "x", None.easeNone, vidro[e.target].x, xTarget, 0.4, true);
			tweenCultura.addEventListener(TweenEvent.MOTION_FINISH, initTweenCultura);
			
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function initTweenCultura(e:TweenEvent):void 
		{
			tweenCultura.removeEventListener(TweenEvent.MOTION_FINISH, initTweenCultura);
			tweenCultura = new Tween(qualCultura, "x", None.easeNone, xTarget, lastX, 0.4, true);
			if (qualPlanta[0] != null && stage.contains(qualPlanta[0])) removeChild(qualPlanta[0]);
			if (qualPlanta[1] != null && stage.contains(qualPlanta[1])) removeChild(qualPlanta[1]);
			if (stage.contains(qualExplante)) removeChild(qualExplante);
		}
		
		private function initTweenCulturaReset(e:TweenEvent):void 
		{
			tweenCultura.removeEventListener(TweenEvent.MOTION_FINISH, initTweenCulturaReset);
			if (stage.contains(raizUm) || stage.contains(explanteUm)) tweenCultura = new Tween(cultura1, "x", None.easeNone, -200, 171, 0.4, true);
			if (stage.contains(raizDois) || stage.contains(explanteDois)) tweenCultura = new Tween(cultura2, "x", None.easeNone, 900, 529, 0.4, true);
			raiz1.gotoAndStop(1);
			raiz2.gotoAndStop(1);
			caule1.gotoAndStop(1);
			caule2.gotoAndStop(1);
			if (stage.contains(raizUm)) removeChild(raizUm);
			if (stage.contains(cauleUm)) removeChild(cauleUm);
			if (stage.contains(raizDois)) removeChild(raizDois);
			if (stage.contains(cauleDois)) removeChild(cauleDois);
			if (stage.contains(explanteUm)) removeChild(explanteUm);
			if (stage.contains(explanteDois)) removeChild(explanteDois);
		}
		
		private function changeSlider(e:Event):void 
		{
			textField[e.target].text = String(e.target.value).replace(".", ",");
		}
		
		private function reset(e:MouseEvent):void 
		{
			trocar1.mouseEnabled = false;
			trocar2.mouseEnabled = false;
			trocar1.alpha = 0.4;
			trocar2.alpha = 0.4;
			semente1.visible = true;
			semente2.visible = true;
			cultura1.enabled = true;
			cultura2.enabled = true;
			slider1A.value = 0;
			slider1B.value = 0;
			slider2A.value = 0;
			slider2B.value = 0;
			textField1A.text = "0";
			textField1B.text = "0";
			textField2A.text = "0";
			textField2B.text = "0";
			
			semente1A = Math.random();
			semente1B = Math.random();
			semente2A = Math.random();
			semente2B = Math.random();
			
			if (stage.contains(raizUm) || stage.contains(explanteUm)) tweenCultura = new Tween(cultura1, "x", None.easeNone, cultura1.x, -200, 0.4, true);
			if (stage.contains(raizDois) || stage.contains(explanteDois)) tweenCultura = new Tween(cultura2, "x", None.easeNone, cultura2.x, 900, 0.4, true);
			if (stage.contains(raizUm)) tweenPlanta1 = new Tween(raizUm, "x", None.easeNone, raizUm.x, -200, 0.4, true);
			if (stage.contains(raizUm)) tweenPlanta2 = new Tween(cauleUm, "x", None.easeNone, cauleUm.x, -200, 0.4, true);
			if (stage.contains(raizDois)) tweenPlanta1 = new Tween(raizDois, "x", None.easeNone, raizDois.x, 900, 0.4, true);
			if (stage.contains(raizDois)) tweenPlanta2 = new Tween(cauleDois, "x", None.easeNone, cauleDois.x, 900, 0.4, true);
			if (stage.contains(explanteUm)) tweenExplante = new Tween(explanteUm, "x", None.easeNone, explanteUm.x, -200, 0.4, true);
			if (stage.contains(explanteDois)) tweenExplante = new Tween(explanteDois, "x", None.easeNone, explanteDois.x, 900, 0.4, true);
			if (stage.contains(raizUm) || stage.contains(raizDois) || stage.contains(explanteUm) || stage.contains(explanteDois)) tweenCultura.addEventListener(TweenEvent.MOTION_FINISH, initTweenCulturaReset);
			
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function playAnimation(cult:MovieClip):void 
		{
			fa1 = fa(slider1A.value, slider1B.value, semente1A, raizUm.totalFrames);
			fb1 = fb(slider1A.value, slider1B.value, semente1B, cauleUm.totalFrames);
			fa2 = fa(slider2A.value, slider2B.value, semente2A, raizUm.totalFrames);
			fb2 = fb(slider2A.value, slider2B.value, semente2B, cauleUm.totalFrames);
			
			planta[cult][0].gotoAndPlay(2);
			planta[cult][1].gotoAndPlay(2);
			
			//e.target.alpha = 0.4;
			//e.target.mouseEnabled = false;
			
			cauleUm.enabled = true;
			raizUm.enabled = true;
			cauleDois.enabled = true;
			raizDois.enabled = true;
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void 
		{
			if (cauleUm.currentFrame == fb1 || cauleUm.currentFrame == 1) {
				cauleUm.stop();
				cauleUm.enabled = false;
			}
			if (raizUm.currentFrame == fa1 || raizUm.currentFrame == 1) {
				raizUm.stop();
				raizUm.enabled = false;
			}
			if (cauleDois.currentFrame == fb2 || cauleDois.currentFrame == 1) {
				cauleDois.stop();
				cauleDois.enabled = false;
			}
			if (raizDois.currentFrame == fa2 || raizDois.currentFrame == 1) {
				raizDois.stop();
				raizDois.enabled = false;
			}
			
			if (!cauleUm.enabled && !raizUm.enabled && !cauleDois.enabled && !raizDois.enabled) removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function fa(a:Number, b:Number, a0:Number, frames:int):int 
		{
			return f(a, a0, frames);
		}
		
		private function fb(a:Number, b:Number, b0:Number, frames:int):int 
		{
			return f(b, b0, frames);
		}
		
		private function f(x:Number, x0:Number, n:int):int
		{
			if (x >= 0.2 && x0 >= x) return Math.round(n * ((x - 0.2) / (x0 - 0.2)));
			else if (x > x0 && x <= 0.8) return Math.round(n * ((x - 0.8) / (x0 - 0.8)));
			
			return 0;
		}
		
		function drag(e:MouseEvent) :void {
			var i:int = 0;
			if (tweenX != null && tweenX.isPlaying) return;
			dragging = e.target as MovieClip;
			setChildIndex(dragging, numChildren - 1);
			stage.addEventListener(MouseEvent.MOUSE_UP, drop);
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			dragging.startDrag();
			dragging.alpha = 0.5;
		}
		
		function drop(e:MouseEvent) :void {
			if (alvo == null) alvo = new MovieClip();
			dragging.alpha = 1;
			stage.removeEventListener(MouseEvent.MOUSE_UP, drop);
			removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			dragging.stopDrag();
			removeFilter(null);
			alvo.enabled = false;
			
			if (alvo.name == "cultura1") {
				if (slider1A.value <= 0.2 || slider1B.value <= 0.2) {
					explanteUm = new (getDefinitionByName(getQualifiedClassName(explante1[dragging][1])));
					addChild(explanteUm);
					explanteUm.x = alvo.x;
					explanteUm.y = alvo.y;
				} else if (slider1A.value >= 0.8 || slider1B.value >= 0.8) {
					explanteUm = new (getDefinitionByName(getQualifiedClassName(explante1[dragging][0])));
					addChild(explanteUm);
					explanteUm.x = alvo.x;
					explanteUm.y = alvo.y;
				} else {
					cauleUm = new (getDefinitionByName(getQualifiedClassName(cultura[dragging][0])));
					raizUm = new (getDefinitionByName(getQualifiedClassName(cultura[dragging][1])));
					addChild(cauleUm);
					addChild(raizUm);
					cauleUm.x = raizUm.x = alvo.x;
					cauleUm.y = raizUm.y = alvo.y;
					planta[cultura1] = [raizUm, cauleUm];
					playAnimation(alvo);
				}
				
				trocar1.mouseEnabled = true;
				trocar1.alpha = 1;
			}
			
			if (alvo.name == "cultura2") {
				if (slider2A.value <= 0.2 || slider2B.value <= 0.2) {
					explanteDois = new (getDefinitionByName(getQualifiedClassName(explante2[dragging][1])));
					addChild(explanteDois);
					explanteDois.x = alvo.x;
					explanteDois.y = alvo.y;
				} else if (slider2A.value >= 0.8 || slider2B.value >= 0.8) {
					explanteDois = new (getDefinitionByName(getQualifiedClassName(explante2[dragging][0])));
					addChild(explanteDois);
					explanteDois.x = alvo.x;
					explanteDois.y = alvo.y;
				} else {
					cauleDois = new (getDefinitionByName(getQualifiedClassName(cultura[dragging][0])));
					raizDois = new (getDefinitionByName(getQualifiedClassName(cultura[dragging][1])));
					addChild(cauleDois);
					addChild(raizDois);
					cauleDois.x = raizDois.x = alvo.x;
					cauleDois.y = raizDois.y = alvo.y;
					planta[cultura2] = [raizDois, cauleDois];
					playAnimation(alvo);
				}
				
				trocar2.mouseEnabled = true;
				trocar2.alpha = 1;
			}
			
			//planta[botaoPlay1] = [raizUm, cauleUm];
			//planta[botaoPlay2] = [raizDois, cauleDois];
			
			if (alvo is Cultura1 || alvo is Cultura2) {
				dragging.x = startPoint[dragging].x;
				dragging.y = startPoint[dragging].y;
			} else {
				tweenX = new Tween(dragging, "x", None.easeNone, dragging.x, startPoint[dragging].x, 0.2, true);
				tweenY = new Tween(dragging, "y", None.easeNone, dragging.y, startPoint[dragging].y, 0.2, true);
			}
			
			
			alvo = null;
		}
		
		private function onMouseMove(e:MouseEvent):void 
		{	
			var peca:MovieClip;
			//alvo = null;
			
			loopForTest: for (var i:int = 1; i <= 2; i++) {
				
				peca = this["cultura" + String(i)];
				//if (peca == dragging) continue;
				
				if (peca.hitTestPoint(dragging.x, dragging.y) && peca.visible && peca.enabled) {
					if (peca.filters.length == 0) peca.filters = [GLOW_FILTER];
					//setChildIndex(peca, Math.max(0, getChildIndex(dragging) - 1));
					removeFilter(peca);
					alvo = MovieClip(peca);
					//break loopForTest;
					return;
				} else {
					peca.filters = [];
				}
			}
			
			alvo = null;
		}
		
		private function removeFilter(peca:MovieClip):void
		{
			var pecaSemFiltro:MovieClip;
			for (var i:int = 1; i <= 2; i++) {
				pecaSemFiltro = this["cultura" + String(i)];
				if (peca != pecaSemFiltro) pecaSemFiltro.filters = [];
			}
		}

		
//Tutorial
		private var posQuadradoArraste:Point = new Point();
		private var balao:CaixaTexto;
		private var pointsTuto:Array;
		private var tutoBaloonPos:Array;
		private var tutoPos:int;
		private var tutoSequence:Array = ["Ajuste a concentração de auxina e cinetina no recipiente acima (unidades arbitrárias).",
										  "Arraste um explante desta planta para um dos recipientes acima.",
										  "Pressione para trocar por um recipiente vazio."];
		/**
		 * Inicia o tutorial da atividade.
		 */								  
		private function iniciaTutorial(e:MouseEvent = null):void 
		{
			tutoPos = 0;
			if(balao == null){
				balao = new CaixaTexto(true);
				addChild(balao);
				setChildIndex(balao, numChildren - 1);
				balao.visible = false;
				
				pointsTuto = 	[new Point(155, 340),
								new Point(200, 460),
								new Point(50, 92)];
								
				tutoBaloonPos = [[CaixaTexto.BOTTON, CaixaTexto.CENTER],
								[CaixaTexto.LEFT, CaixaTexto.CENTER],
								[CaixaTexto.LEFT, CaixaTexto.CENTER]];
			}
			
			balao.removeEventListener(Event.CLOSE, closeBalao);
			balao.setText(tutoSequence[tutoPos], tutoBaloonPos[tutoPos][0], tutoBaloonPos[tutoPos][1]);
			balao.setPosition(pointsTuto[tutoPos].x, pointsTuto[tutoPos].y);
			balao.addEventListener(Event.CLOSE, closeBalao);
			balao.visible = true;
			setChildIndex(balao, numChildren - 1);
		}
		
		private function closeBalao(e:Event):void 
		{
			tutoPos++;
			if (tutoPos >= tutoSequence.length) {
				balao.removeEventListener(Event.CLOSE, closeBalao);
				balao.visible = false;
				
			}else {
				balao.setText(tutoSequence[tutoPos], tutoBaloonPos[tutoPos][0], tutoBaloonPos[tutoPos][1]);
				balao.setPosition(pointsTuto[tutoPos].x, pointsTuto[tutoPos].y);
			}
		}
		
		/*------------------------------------------------------------------------------------------------*/
		//SCORM:
		
		private const PING_INTERVAL:Number = 5 * 60 * 1000; // 5 minutos
		private var completed:Boolean;
		private var scorm:SCORM;
		private var scormExercise:int;
		private var connected:Boolean;
		private var score:Number = 0;
		private var pingTimer:Timer;
		private var mementoSerialized:String = "";
		
		/**
		 * @private
		 * Inicia a conexão com o LMS.
		 */
		private function initLMSConnection () : void
		{
			completed = false;
			connected = false;
			scorm = new SCORM();
			
			pingTimer = new Timer(PING_INTERVAL);
			pingTimer.addEventListener(TimerEvent.TIMER, pingLMS);
			
			connected = scorm.connect();
			
			if (connected) {
				// Verifica se a AI já foi concluída.
				scorm.set("cmi.exit", "suspend");
				var status:String = scorm.get("cmi.completion_status");	
				mementoSerialized = String(scorm.get("cmi.suspend_data"));
				var stringScore:String = scorm.get("cmi.score.raw");
			 
				switch(status)
				{
					// Primeiro acesso à AI
					case "not attempted":
					case "unknown":
					default:
						completed = false;
						break;
					
					// Continuando a AI...
					case "incomplete":
						completed = false;
						break;
					
					// A AI já foi completada.
					case "completed":
						completed = true;
						//setMessage("ATENÇÃO: esta Atividade Interativa já foi completada. Você pode refazê-la quantas vezes quiser, mas não valerá nota.");
						break;
				}
				
				//unmarshalObjects(mementoSerialized);
				scormExercise = 1;
				score = Number(stringScore.replace(",", "."));
				//txNota.text = score.toFixed(1).replace(".", ",");
				
				var success:Boolean = scorm.set("cmi.score.min", "0");
				if (success) success = scorm.set("cmi.score.max", "100");
				
				if (success)
				{
					scorm.save();
					pingTimer.start();
				}
				else
				{
					//trace("Falha ao enviar dados para o LMS.");
					connected = false;
				}
			}
			else
			{
				trace("Esta Atividade Interativa não está conectada a um LMS: seu aproveitamento nela NÃO será salvo.");
				mementoSerialized = ExternalInterface.call("getLocalStorageString");
			}
			
			//reset();
		}
		
		/**
		 * @private
		 * Salva cmi.score.raw, cmi.location e cmi.completion_status no LMS
		 */ 
		private function commit():void
		{
			if (connected)
			{
				// Salva no LMS a nota do aluno.
				var success:Boolean = scorm.set("cmi.score.raw", score.toString());

				// Notifica o LMS que esta atividade foi concluída.
				success = scorm.set("cmi.completion_status", (completed ? "completed" : "incomplete"));

				// Salva no LMS o exercício que deve ser exibido quando a AI for acessada novamente.
				success = scorm.set("cmi.location", scormExercise.toString());
				
				// Salva no LMS a string que representa a situação atual da AI para ser recuperada posteriormente.
				//mementoSerialized = marshalObjects();
				//success = scorm.set("cmi.suspend_data", mementoSerialized.toString());

				if (success)
				{
					scorm.save();
				}
				else
				{
					pingTimer.stop();
					//setMessage("Falha na conexão com o LMS.");
					connected = false;
				}
			}else { //LocalStorage
				ExternalInterface.call("save2LS", mementoSerialized);
			}
		}
		
		/**
		 * @private
		 * Mantém a conexão com LMS ativa, atualizando a variável cmi.session_time
		 */
		private function pingLMS (event:TimerEvent):void
		{
			//scorm.get("cmi.completion_status");
			commit();
		}
		
		private function saveStatus():void
		{
			if (ExternalInterface.available) {
				if (connected) {
					scorm.set("cmi.suspend_data", mementoSerialized);
					commit();
				}else {//LocalStorage
					ExternalInterface.call("save2LS", mementoSerialized);
				}
			}
		}
		
		private function makeoverOut(btn:MovieClip):void
		{
			btn.mouseChildren = false;
			btn.addEventListener(MouseEvent.MOUSE_OVER, over);
			btn.addEventListener(MouseEvent.MOUSE_OUT, out);
		}
		
		private function over(e:MouseEvent):void
		{
			var btn:MovieClip = MovieClip(e.target);
			btn.gotoAndStop(2);
		}
		
		private function out(e:MouseEvent):void
		{
			var btn:MovieClip = MovieClip(e.target);
			btn.gotoAndStop(1);
		}
	}

}