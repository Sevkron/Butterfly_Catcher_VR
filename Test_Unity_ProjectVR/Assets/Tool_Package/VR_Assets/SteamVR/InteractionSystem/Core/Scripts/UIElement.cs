﻿//======= Copyright (c) Valve Corporation, All rights reserved. ===============
//
// Purpose: UIElement that responds to VR hands and generates UnityEvents
//
//=============================================================================

using UnityEngine;
using UnityEngine.Events;
using UnityEngine.UI;
using System;

namespace Valve.VR.InteractionSystem
{
	//-------------------------------------------------------------------------
	[RequireComponent( typeof( Interactable ) )]
	public class UIElement : MonoBehaviour
	{
		public CustomEvents.UnityEventHand onHandClick;
		public BoxCollider buttonPress;
		public BoxCollider buttonHover;
        protected Hand currentHand;

		//-------------------------------------------------
		protected virtual void Awake()
		{
			Button button = GetComponent<Button>();
			if ( button )
			{
				button.onClick.AddListener( OnButtonClick );
			}
			buttonPress = gameObject.GetComponent<BoxCollider>();
		}


		//-------------------------------------------------
		protected virtual void OnHandHoverBegin( Hand hand )
		{
			currentHand = hand;
			InputModule.instance.HoverBegin( gameObject );
			InputModule.instance.Submit( gameObject );
			Debug.Log("Wrong button press");
			//ControllerButtonHints.ShowButtonHint( hand, hand.uiInteractAction);
		}


        //-------------------------------------------------
        protected virtual void OnHandHoverEnd( Hand hand )
		{
			InputModule.instance.HoverEnd( gameObject );
			ControllerButtonHints.HideButtonHint( hand, hand.uiInteractAction);
			currentHand = null;
		}


        //-------------------------------------------------
        protected virtual void HandHoverUpdate( Hand hand )
		{
			if ( hand.uiInteractAction != null && hand.uiInteractAction.GetStateDown(hand.handType) )
			{
				InputModule.instance.Submit( gameObject );
				ControllerButtonHints.HideButtonHint( hand, hand.uiInteractAction);
				Debug.Log("Hand Hover Update");
			}
		}

		void OnTriggerEnter(Collider other)
		{
			if(other.gameObject == currentHand)
			{
				InputModule.instance.HoverBegin( gameObject );
				Debug.Log("Pressed button");
			}
		}
		void OnTriggerExit(Collider other)
		{
			if(other.gameObject == currentHand)
			{
				InputModule.instance.HoverEnd( gameObject );
				Debug.Log("Pressed button");
			}
		}

        //-------------------------------------------------
        protected virtual void OnButtonClick()
		{
			onHandClick.Invoke( currentHand );
		}
	}

#if UNITY_EDITOR
	//-------------------------------------------------------------------------
	[UnityEditor.CustomEditor( typeof( UIElement ) )]
	public class UIElementEditor : UnityEditor.Editor
	{
		//-------------------------------------------------
		// Custom Inspector GUI allows us to click from within the UI
		//-------------------------------------------------
		public override void OnInspectorGUI()
		{
			DrawDefaultInspector();

			UIElement uiElement = (UIElement)target;
			if ( GUILayout.Button( "Click" ) )
			{
				InputModule.instance.Submit( uiElement.gameObject );
			}
		}
	}
#endif
}
