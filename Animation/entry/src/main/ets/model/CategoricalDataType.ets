export interface PrimaryCategory {
  image:Resource
  title: Resource,
  childNodes: SecondaryCategory[]
}

export interface SecondaryCategory {
  image:Resource,
  title: Resource,
  url: string,
}
export interface TertiaryCategory {
  image: Resource,
  title: Resource,
  url?: string,
  childNodes?: QuaternaryCategory[]
}
export interface QuaternaryCategory {
  title: Resource, // Fourth-level category titles
  url: string // Fourth-level category detail page URL
}