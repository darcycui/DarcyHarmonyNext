import { IUIBean } from "../../IUIBean";
import { LearnPages } from "./LearnPages";

/**
 * 首页列表项 Bean
 *
 * 对应 Kotlin 中的 HomeItemBean
 * 字段映射：
 *   - id         : 项 ID（Int，默认 -1）
 *   - title      : 标题（String）
 *   - learnPages : 学习页面枚举（LearnPages）
 */
export class HomeItemBean implements IUIBean {
  /**
   * 项 ID
   */
  id: number = -1;

  /**
   * 标题
   */
  title: string = '';

  /**
   * 学习页面
   */
  learnPages: LearnPages = LearnPages.UnknownPage;

  constructor(id?: number, title?: string, learnPages?: LearnPages) {
    if (id !== undefined) {
      this.id = id;
    }
    if (title !== undefined) {
      this.title = title;
    }
    if (learnPages !== undefined) {
      this.learnPages = learnPages;
    }
  }
}
