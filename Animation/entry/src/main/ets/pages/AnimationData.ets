import { TertiaryCategory } from '../model/CategoricalDataType'

const TRANSITION_ANIMATION: TertiaryCategory =
  {
    image: $r('app.media.ic_transition_animation'),
    title: $r('app.string.transition_animation'),
    childNodes: [
      {
        title: $r('app.string.page_transition'),
        url: 'pages/TransitionAnimations/pageTransitionSample/PageTransitionSample'
      },
      {
        title: $r('app.string.share_element_transition'),
        url: 'pages/TransitionAnimations/shareElementTransitionSample/ShareElementTransitionSample'
      },
      {
        title: $r('app.string.Multiplex_interface'),
        url: 'pages/TransitionAnimations/multiplexSample/MultiplexSample',
      },
      {
        title: $r('app.string.Floating_window'),
        url: 'pages/TransitionAnimations/floatingSample/FloatingWindowSample',
      },
      {
        title: $r('app.string.Folder_expansion'),
        url: 'pages/TransitionAnimations/folderSample/FolderSample',
      },
      {
        title: $r('app.string.System_icon'),
        url: 'pages/TransitionAnimations/systemIcon/SystemIcon',
      },
      {
        title: $r('app.string.Shop_card_expansion'),
        url: 'pages/TransitionAnimations/shopSample/ShopCardSample',
      },
      {
        title: $r('app.string.Gallery_card_expansion'),
        url: 'pages/TransitionAnimations/gallerySample/GalleryCardSample',
      },
      {
        title: $r('app.string.component_transition'),
        url: 'pages/TransitionAnimations/componentTransitionSample/ComponentTransitionSample',
      },
      {
        title: $r('app.string.layout_animation_expansion'),
        url: 'pages/TransitionAnimations/layoutAnimationSample/LayoutAnimationSample',
      },
      {
        title: $r('app.string.size_transition_expansion'),
        url: 'pages/TransitionAnimations/sizeTransitionSample/SizeTransitionSample',
      },
      {
        title: $r('app.string.side_bar_effects_title'),
        url: 'pages/TransitionAnimations/sideBarTransitionSample/SideBarTransitionSample',
      }
    ]
  }

const INTERPOLATION_CALCULATION: TertiaryCategory =
  {
    image: $r('app.media.ic_interpolation_calculation'),
    title: $r('app.string.interpolation_calculation'),
    url: 'pages/interpolationCalculationSample/InterpolationCalculationSample',
  }

const ANIMATE_TO: TertiaryCategory =
  {
    image: $r("app.media.ic_animations_animate"),
    title: $r('app.string.animate_to'),
    url: 'pages/animateToSample/AnimateToSample'
  }

const ANIMATION_ATTRIBUTE: TertiaryCategory =
  {
    image: $r('app.media.ic_animations_animation'),
    title: $r('app.string.attribute_animation'),
    url: 'pages/animationSample/AnimationSample'
  }

const MOTION_PATH: TertiaryCategory =
  {
    image: $r('app.media.ic_animations_path'),
    title: $r('app.string.motion_path'),
    url: 'pages/motionPathSample/MotionPathSample'
  }
export const ANIMATION_CATEGORIES: TertiaryCategory[]= [TRANSITION_ANIMATION, INTERPOLATION_CALCULATION, ANIMATE_TO, ANIMATION_ATTRIBUTE, MOTION_PATH]