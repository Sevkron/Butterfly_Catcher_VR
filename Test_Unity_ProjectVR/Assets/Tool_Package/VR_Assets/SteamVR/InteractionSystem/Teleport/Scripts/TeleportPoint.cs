//======= Copyright (c) Valve Corporation, All rights reserved. ===============
//
// Purpose: Single location that the player can teleport to
//
//=============================================================================

using UnityEngine;
using UnityEngine.UI;
#if UNITY_EDITOR
using UnityEditor;
using UnityEngine.SceneManagement;
#endif

namespace Valve.VR.InteractionSystem
{
	//-------------------------------------------------------------------------
	public class TeleportPoint : TeleportMarkerBase
	{
		public enum TeleportPointType
		{
			MoveToLocation,
			SwitchToNewScene,
			ExitGame
		};
		//Public variables
		public TeleportPointType teleportType = TeleportPointType.MoveToLocation;
		public string title;
		public string switchToScene;
		public string exitGame;
		public Color titleVisibleColor;
		public Color titleHighlightedColor;
		public Color titleLockedColor;
		public bool playerSpawnPoint = false;
		public bool baseTeleportPoint = false;
		public GameObject m_changeSceneGO;
		public GameObject m_papillodex;

		//Private data
		private bool gotReleventComponents = false;
		private MeshRenderer markerMesh;
		private MeshRenderer switchSceneIcon;
		private MeshRenderer moveLocationIcon;
		private MeshRenderer quitIcon;
		private MeshRenderer lockedIcon;
		private MeshRenderer pointIcon;
		private Transform lookAtJointTransform;
		private new Animation animation;
		private Text titleText;
		private Player player;
		private Vector3 lookAtPosition = Vector3.zero;
		private int tintColorID = 0;
		private Color tintColor = Color.clear;
		private Color titleColor = Color.clear;
		private float fullTitleAlpha = 0.0f;
		private GameObject LevelLoader;

		//Constants
		//private const string switchSceneAnimation = "switch_scenes_idle";
		private const string switchSceneAnimation = "switchsceness_butterfly_idle";
		private const string moveLocationAnimation = "move_location_idle";
		private const string lockedAnimation = "locked_idle";


		//-------------------------------------------------
		public override bool showReticle
		{
			get
			{
				return false;
			}
		}


		//-------------------------------------------------
		void Awake()
		{
			GetRelevantComponents();

			animation = GetComponent<Animation>();

			tintColorID = Shader.PropertyToID( "_TintColor" );

			moveLocationIcon.gameObject.SetActive( false );
			switchSceneIcon.gameObject.SetActive( false );
			lockedIcon.gameObject.SetActive( false );

			UpdateVisuals();
		}


		//-------------------------------------------------
		void Start()
		{
			player = Player.instance;
		}


		//-------------------------------------------------
		void Update()
		{
			if ( Application.isPlaying )
			{
				lookAtPosition.x = player.hmdTransform.position.x;
				lookAtPosition.y = lookAtJointTransform.position.y;
				lookAtPosition.z = player.hmdTransform.position.z;

				lookAtJointTransform.LookAt( lookAtPosition );
			}
		}


		//-------------------------------------------------
		public override bool ShouldActivate( Vector3 playerPosition )
		{
			return ( Vector3.Distance( transform.position, playerPosition ) > 1.0f );
		}


		//-------------------------------------------------
		public override bool ShouldMovePlayer()
		{
			return true;
		}


		//-------------------------------------------------
		public override void Highlight( bool highlight )
		{
			if ( !locked )
			{
				if ( highlight )
				{
					SetMeshMaterials( Teleport.instance.pointHighlightedMaterial, titleHighlightedColor );
				}
				else
				{
					SetMeshMaterials( Teleport.instance.pointVisibleMaterial, titleVisibleColor );
				}
			}

			if ( highlight )
			{
				pointIcon.gameObject.SetActive( true );
				animation.Play();
			}
			else
			{
				pointIcon.gameObject.SetActive( false );
				animation.Stop();
			}
		}


		//-------------------------------------------------
		public override void UpdateVisuals()
		{
			if ( !gotReleventComponents )
			{
				return;
			}

			if ( locked )
			{
				SetMeshMaterials( Teleport.instance.pointLockedMaterial, titleLockedColor );

				pointIcon = lockedIcon;

				animation.clip = animation.GetClip( lockedAnimation );
			}
			else
			{
				SetMeshMaterials( Teleport.instance.pointVisibleMaterial, titleVisibleColor );

				switch ( teleportType )
				{
					case TeleportPointType.MoveToLocation:
						{
							pointIcon = moveLocationIcon;

							animation.clip = animation.GetClip( moveLocationAnimation );
						}
						break;
					case TeleportPointType.SwitchToNewScene:
						{
							pointIcon = switchSceneIcon;

							animation.clip = animation.GetClip( switchSceneAnimation );
						}
						break;
				}
			}

			titleText.text = title;
		}


		//-------------------------------------------------
		public override void SetAlpha( float tintAlpha, float alphaPercent )
		{
			tintColor = markerMesh.material.GetColor( tintColorID );
			tintColor.a = tintAlpha;

			markerMesh.material.SetColor( tintColorID, tintColor );
			switchSceneIcon.material.SetColor( tintColorID, tintColor );
			moveLocationIcon.material.SetColor( tintColorID, tintColor );
			//quitIcon.material.SetColor(tintColorID,tintColor);
			lockedIcon.material.SetColor( tintColorID, tintColor );

			titleColor.a = fullTitleAlpha * alphaPercent;
			titleText.color = titleColor;
		}


		//-------------------------------------------------
		public void SetMeshMaterials( Material material, Color textColor )
		{
			markerMesh.material = material;
			switchSceneIcon.material = material;
			moveLocationIcon.material = material;
			//quitIcon.material = material;
			lockedIcon.material = material;

			titleColor = textColor;
			fullTitleAlpha = textColor.a;
			titleText.color = titleColor;
		}


		//-------------------------------------------------
		public void TeleportToScene()
		{
			if(switchToScene == "EXIT") 
			{
				Application.Quit();
				Debug.Log("<b>[SteamVR Interaction]</b> TeleportPoint: application is now quitting " + switchToScene, this);
			}
			else if(switchToScene == "LDScene")
			{
				m_changeSceneGO.GetComponent<SteamVR_LoadLevel>().enabled = true;
				m_papillodex.SetActive(true);
			}
			else if( !string.IsNullOrEmpty( switchToScene ) )
			{
				//LevelLoader = GameObject.Find("SwitchScene");
				m_changeSceneGO.GetComponent<SteamVR_LoadLevel>().enabled = true;
				//SteamVR_LoadLevel.Begin(switchToScene, false, 0.5f, 1.0f, 0.5f, 0, 1);
				Debug.Log("<b>[SteamVR Interaction]</b> TeleportPoint: Hook up your level loading logic to switch to new scene: " + switchToScene, this);
			}
			else
			{
				Debug.LogError("<b>[SteamVR Interaction]</b> TeleportPoint: Invalid scene name to switch to: " + switchToScene, this);
			}
		}

		public void ExitGame()
		{
			if ( !string.IsNullOrEmpty( exitGame ) )
			{
				Application.Quit();
				Debug.Log("Game is exited", this);
			}
			else
			{
				Debug.LogError("Didn't exit game", this);
			}
		}

		//-------------------------------------------------
		public void GetRelevantComponents()
		{
			markerMesh = transform.Find( "teleport_marker_mesh" ).GetComponent<MeshRenderer>();
			switchSceneIcon = transform.Find( "teleport_marker_lookat_joint/teleport_marker_icons/switch_scenes_icon" ).GetComponent<MeshRenderer>();
			moveLocationIcon = transform.Find( "teleport_marker_lookat_joint/teleport_marker_icons/move_location_icon" ).GetComponent<MeshRenderer>();
			//quitIcon = transform.Find( "XMeshUv" ).GetComponent<MeshRenderer>();
			lockedIcon = transform.Find( "teleport_marker_lookat_joint/teleport_marker_icons/locked_icon" ).GetComponent<MeshRenderer>();
			lookAtJointTransform = transform.Find( "teleport_marker_lookat_joint" );

			titleText = transform.Find( "teleport_marker_lookat_joint/teleport_marker_canvas/teleport_marker_canvas_text" ).GetComponent<Text>();

			gotReleventComponents = true;
		}


		//-------------------------------------------------
		public void ReleaseRelevantComponents()
		{
			markerMesh = null;
			switchSceneIcon = null;
			moveLocationIcon = null;
			//quitIcon = null;
			lockedIcon = null;
			lookAtJointTransform = null;
			titleText = null;
		}


		//-------------------------------------------------
		public void UpdateVisualsInEditor()
		{
			if ( Application.isPlaying )
			{
				return;
			}

			GetRelevantComponents();

			if ( locked )
			{
				lockedIcon.gameObject.SetActive( true );
				moveLocationIcon.gameObject.SetActive( false );
				switchSceneIcon.gameObject.SetActive( false );
				//quitIcon.gameObject.SetActive(false);

				markerMesh.sharedMaterial = Teleport.instance.pointLockedMaterial;
				lockedIcon.sharedMaterial = Teleport.instance.pointLockedMaterial;

				titleText.color = titleLockedColor;
			}
			else
			{
				lockedIcon.gameObject.SetActive( false );

				markerMesh.sharedMaterial = Teleport.instance.pointVisibleMaterial;
				switchSceneIcon.sharedMaterial = Teleport.instance.pointVisibleMaterial;
				moveLocationIcon.sharedMaterial = Teleport.instance.pointVisibleMaterial;
				//quitIcon.sharedMaterial = Teleport.instance.pointVisibleMaterial;

				titleText.color = titleVisibleColor;

				switch ( teleportType )
				{
					case TeleportPointType.MoveToLocation:
						{
							moveLocationIcon.gameObject.SetActive( true );
							switchSceneIcon.gameObject.SetActive( false );
							//quitIcon.gameObject.SetActive(false);
						}
						break;
					case TeleportPointType.SwitchToNewScene:
						{
							moveLocationIcon.gameObject.SetActive( false );
							switchSceneIcon.gameObject.SetActive( true );
							//quitIcon.gameObject.SetActive(false);
						}
						break;
				}
			}

			titleText.text = title;

			ReleaseRelevantComponents();
		}
	}


#if UNITY_EDITOR
	//-------------------------------------------------------------------------
	[CustomEditor( typeof( TeleportPoint ) )]
	public class TeleportPointEditor : Editor
	{
		//-------------------------------------------------
		void OnEnable()
		{
			if ( Selection.activeTransform )
			{
				TeleportPoint teleportPoint = Selection.activeTransform.GetComponent<TeleportPoint>();
                if (teleportPoint != null)
				    teleportPoint.UpdateVisualsInEditor();
			}
		}


		//-------------------------------------------------
		public override void OnInspectorGUI()
		{
			DrawDefaultInspector();

			if ( Selection.activeTransform )
			{
				TeleportPoint teleportPoint = Selection.activeTransform.GetComponent<TeleportPoint>();
				if ( GUI.changed )
				{
					teleportPoint.UpdateVisualsInEditor();
				}
			}
		}
	}
#endif
}
