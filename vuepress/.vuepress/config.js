module.exports = {
  dest: '../docs',
  /// base 值应当总是以斜杠开始，并以斜杠结束
  base: '/',
  ///
  title: 'DiscuzQ Mobile App Doc',
  description: 'DiscuzQ App document for building your application',
  head: [
    ['link', { rel: 'icon', href: '/logo.png' }]
  ],
  themeConfig: {
    nav: [
      { text: '快速构建', link: '/docs/build' },
      { text: '二次开发', link: '/docs/develop' },
      { text: 'Github', link: 'https://github.com/virskor/DiscuzQ' },
    ],
    // 添加侧边栏
    sidebar: 'auto',
    sidebarDepth: 2
  },
  plugins: [
    '@vuepress/back-to-top',
    ///'@vuepress/pwa',
    '@vuepress/active-header-links',
    {
      sidebarLinkSelector: '.sidebar-link',
      headerAnchorSelector: '.header-anchor'
    }
  ]
}