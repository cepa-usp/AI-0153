package  
{
	import fl.controls.Slider;
	import cepa.utils.ToolTip;
	import fl.transitions.easing.None;
	import fl.transitions.Tween;
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
		private var botaoPlay:Dictionary = new Dictionary();
		private var slider:Dictionary = new Dictionary();
		private var fa1:int;
		private var fb1:int;
		private var fa2:int;
		private var fb2:int;
		private var raizUm:MovieClip = new MovieClip();
		private var raizDois:MovieClip = new MovieClip();
		private var cauleUm:MovieClip = new MovieClip();
		private var cauleDois:MovieClip = new MovieClip();
		
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
			
			botaoPlay1.addEventListener(MouseEvent.MOUSE_DOWN, playAnimation);
			botaoPlay2.addEventListener(MouseEvent.MOUSE_DOWN, playAnimation);
			semente1.addEventListener(MouseEvent.MOUSE_DOWN, drag);
			semente2.addEventListener(MouseEvent.MOUSE_DOWN, drag);
			slider1A.addEventListener(Event.CHANGE, changeSlider);
			slider1B.addEventListener(Event.CHANGE, changeSlider);
			slider2A.addEventListener(Event.CHANGE, changeSlider);
			slider2B.addEventListener(Event.CHANGE, changeSlider);
			trocar1.addEventListener(MouseEvent.CLICK, resetCultura);
			trocar2.addEventListener(MouseEvent.CLICK, resetCultura);
			
			menu.resetBtn.addEventListener(MouseEvent.CLICK, reset);
			/*feedbackCerto.botaoOK.addEventListener(MouseEvent.CLICK, function () { feedbackCerto.visible = false; } );
			feedbackErrado.botaoOK.addEventListener(MouseEvent.CLICK, function () { feedbackErrado.visible = false; } );
			menu.instructionsBtn.addEventListener(MouseEvent.CLICK, function () { infoScreen.visible = true; setChildIndex(infoScreen, numChildren - 1); } );
			infoScreen.addEventListener(MouseEvent.CLICK, function () { infoScreen.visible = false; } );
			stage.addEventListener(KeyboardEvent.KEY_DOWN, function (e:KeyboardEvent) { if (KeyboardEvent(e).keyCode == Keyboard.ESCAPE) infoScreen.visible = false;} );
			menu.creditosBtn.addEventListener(MouseEvent.CLICK, function () { aboutScreen.visible = true; setChildIndex(aboutScreen, numChildren - 1); } );
			aboutScreen.addEventListener(MouseEvent.CLICK, function () { aboutScreen.visible = false; } );
			*/
			//makeoverOut(feedbackCerto.botaoOK);
			//makeoverOut(feedbackErrado.botaoOK);
			makeoverOut(menu.tutorialBtn);
			makeoverOut(menu.instructionsBtn);
			makeoverOut(menu.creditosBtn);
			makeoverOut(menu.resetBtn);
			
			//stage.addEventListener(KeyboardEvent.KEY_DOWN, function (e:KeyboardEvent) { if (KeyboardEvent(e).keyCode == Keyboard.ESCAPE) aboutScreen.visible = false;} );
			
			menu.tutorialBtn.buttonMode = true;
			menu.instructionsBtn.buttonMode = true;
			menu.resetBtn.buttonMode = true;
			menu.creditosBtn.buttonMode = true;
			botaoPlay1.buttonMode = true;
			botaoPlay2.buttonMode = true;
			botaoPlay1.mouseEnabled = false;
			botaoPlay2.mouseEnabled = false;
			botaoPlay1.alpha = 0.4;
			botaoPlay2.alpha = 0.4;
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
			planta[botaoPlay1] = ["raizUm", "cauleUm"];
			planta[botaoPlay2] = ["raizDois", "cauleDois"];
			hormonioA[botaoPlay1] = semente1A;
			hormonioB[botaoPlay1] = semente1B;
			hormonioA[botaoPlay2] = semente2A;
			hormonioB[botaoPlay2] = semente2B;
			textField[slider1A] = textField1A;
			textField[slider1B] = textField1B;
			textField[slider2A] = textField2A;
			textField[slider2B] = textField2B;
			cultura[semente1] = [caule1, raiz1];
			cultura[semente2] = [caule2, raiz2];
			vidro[trocar1] = cultura1;
			vidro[trocar2] = cultura2;
			semente[caule1] = semente1;
			semente[caule2] = semente2;
			startPoint[semente1] = new Point(semente1.x, semente1.y);
			startPoint[semente2] = new Point(semente2.x, semente2.y);
			botaoPlay[trocar1] = botaoPlay1;
			botaoPlay[trocar2] = botaoPlay2;
			slider[trocar1] = [slider1A, slider1B];
			slider[trocar2] = [slider2A, slider2B];
			
			slider1A.liveDragging = true;
			slider1B.liveDragging = true;
			slider2A.liveDragging = true;
			slider2B.liveDragging = true;
			
			var ttinfo:ToolTip = new ToolTip(menu.instructionsBtn, "Orientações", 11, 0.8, 200, 0.6, 0.1);
			addChild(ttinfo);
			var ttreset:ToolTip = new ToolTip(menu.resetBtn, "Nova tentativa", 11, 0.8, 200, 0.6, 0.1);
			addChild(ttreset);
			var ttcc:ToolTip = new ToolTip(menu.creditosBtn, "Créditos", 11, 0.8, 200, 0.6, 0.1);
			addChild(ttcc);
			
			//feedbackCerto.botaoOK.buttonMode = true;
			//feedbackErrado.botaoOK.buttonMode = true;
			
			//infoScreen.visible = false;
			//aboutScreen.visible = false;
			
			semente1A = Math.random();
			semente1B = Math.random();
			semente2A = Math.random();
			semente2B = Math.random();
		}
		
		private function resetCultura(e:MouseEvent):void 
		{
			e.target.mouseEnabled = false;
			e.target.alpha = 0.4;
			planta[botaoPlay[e.target]][0].gotoAndStop(1);
			planta[botaoPlay[e.target]][1].gotoAndStop(1);
			removeChild(planta[botaoPlay[e.target]][0]);
			removeChild(planta[botaoPlay[e.target]][1]);
			trace(this[planta[botaoPlay[e.target]][1].name].name);
			//semente[this[planta[botaoPlay[e.target]][1]]].visible = true;
			trace("2");
			vidro[e.target].enabled = true;
			trace("3");
			botaoPlay[e.target].mouseEnabled = false;
			trace("4");
			botaoPlay[e.target].alpha = 0.4;
/*			slider[e.target][0].value = 0;
			slider[e.target][1].value = 0;
			textField[slider[e.target][0]].text = "0";
			textField[slider[e.target][1]].text = "0";
			
			semente1A = Math.random();
			semente1B = Math.random();
			semente2A = Math.random();
			semente2B = Math.random();
*/			
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
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
			raiz1.gotoAndStop(1);
			raiz2.gotoAndStop(1);
			caule1.gotoAndStop(1);
			caule2.gotoAndStop(1);
			if (stage.contains(raiz1)) removeChild(raiz1);
			if (stage.contains(caule1)) removeChild(caule1);
			if (stage.contains(raiz2)) removeChild(raiz2);
			if (stage.contains(caule2)) removeChild(caule2);
			semente1.visible = true;
			semente2.visible = true;
			cultura1.enabled = true;
			cultura2.enabled = true;
			botaoPlay1.mouseEnabled = false;
			botaoPlay2.mouseEnabled = false;
			botaoPlay1.alpha = 0.4;
			botaoPlay2.alpha = 0.4;
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
			
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function playAnimation(e:MouseEvent):void 
		{
			fa1 = fa(slider1A.value, slider1B.value, semente1A, raizUm.totalFrames);
			fb1 = fb(slider1A.value, slider1B.value, semente1B, cauleUm.totalFrames);
			fa2 = fa(slider2A.value, slider2B.value, semente2A, raizUm.totalFrames);
			fb2 = fb(slider2A.value, slider2B.value, semente2B, cauleUm.totalFrames);
			
			planta[e.target][0].play();
			planta[e.target][1].play();
			
			e.target.alpha = 0.4;
			e.target.mouseEnabled = false;
			
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
			if (x >= 0 && x0 >= x) return Math.round(n * (x / x0));
			else if (x > x0 && x <= 1) return Math.round(n * ((1 - x) / (1 - x0)));
			
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
			dragging.gotoAndStop(1);
			stage.removeEventListener(MouseEvent.MOUSE_UP, drop);
			removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			dragging.stopDrag();
			removeFilter(null);
			alvo.enabled = false;
			
			if (alvo.name == "cultura1") {
				cauleUm = new (getDefinitionByName(getQualifiedClassName(cultura[dragging][0])));
				raizUm = new (getDefinitionByName(getQualifiedClassName(cultura[dragging][1])));
				cauleUm.name = "cauleUm";
				raizUm.name = "raizUm";
				planta[botaoPlay1] = [raizUm, cauleUm];
				addChild(cauleUm);
				addChild(raizUm);
				cauleUm.x = raizUm.x = alvo.x;
				cauleUm.y = raizUm.y = alvo.y;
				botaoPlay1.mouseEnabled = true;
				botaoPlay1.alpha = 1;
				trocar1.mouseEnabled = true;
				trocar1.alpha = 1;
			}
			
			if (alvo.name == "cultura2") {
				cauleDois = new (getDefinitionByName(getQualifiedClassName(cultura[dragging][0])));
				raizDois = new (getDefinitionByName(getQualifiedClassName(cultura[dragging][1])));
				planta[botaoPlay2] = [raizDois, cauleDois];
				addChild(cauleDois);
				addChild(raizDois);
				cauleDois.x = raizDois.x = alvo.x;
				cauleDois.y = raizDois.y = alvo.y;
				botaoPlay2.mouseEnabled = true;
				botaoPlay2.alpha = 1;
				trocar2.mouseEnabled = true;
				trocar2.alpha = 1;
			}
			
			planta[botaoPlay1] = [raizUm, cauleUm];
			planta[botaoPlay2] = [raizDois, cauleDois];
			
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