import { WorkflowConfig } from '@/types/workflow';

export const workflows: WorkflowConfig[] = [
  {
    id: 'vps-knowledge',
    title: 'VPS知识库',
    description: '记录常用的脚本和密码，VPS管理相关的知识库助手',
    difyUrl: 'http://dify.sop.design/chatbot/5xviFcRKCkWM1EWD',
    category: 'assistant',
    tags: ['VPS', '密码', '脚本'],
    openMode: 'modal'
  },
  {
    id: 'content-generator',
    title: '内容创作助手',
    description: '专业的内容创作工具，支持文章写作、广告文案、社交媒体内容生成',
    difyUrl: 'https://udify.app/chat/your-content-generator-id',
    category: 'creative',
    tags: ['写作', '文案', '创作'],
    openMode: 'modal'
  },
  {
    id: 'data-analyzer',
    title: '数据分析工具',
    description: '智能数据分析助手，帮助您分析数据、生成报告和洞察',
    difyUrl: 'https://udify.app/chat/your-analyzer-id',
    category: 'analysis',
    tags: ['数据', '分析', '报告'],
    openMode: 'new_tab'
  },
  {
    id: 'code-reviewer',
    title: '代码审查助手',
    description: '专业的代码审查工具，提供代码质量评估、最佳实践建议',
    difyUrl: 'https://udify.app/chat/your-code-reviewer-id',
    category: 'development',
    tags: ['代码', '审查', '开发'],
    openMode: 'modal'
  },
  {
    id: 'translation-tool',
    title: '多语言翻译',
    description: '智能翻译工具，支持多种语言间的准确翻译和本地化',
    difyUrl: 'https://udify.app/chat/your-translator-id',
    category: 'language',
    tags: ['翻译', '多语言', '本地化'],
    openMode: 'modal'
  },
  {
    id: 'business-consultant',
    title: '商业咨询顾问',
    description: '专业商业咨询工具，提供市场分析、策略建议和业务优化方案',
    difyUrl: 'https://udify.app/chat/your-consultant-id',
    category: 'business',
    tags: ['商业', '咨询', '策略'],
    openMode: 'new_tab'
  },
  {
    id: 'business-consultant',
    title: '商业咨询顾问',
    description: '专业商业咨询工具，提供市场分析、策略建议和业务优化方案',
    difyUrl: 'https://udify.app/chat/your-consultant-id',
    category: 'business',
    tags: ['商业', '咨询', '策略'],
    openMode: 'new_tab'
  }
];

export function getWorkflowById(id: string): WorkflowConfig | undefined {
  return workflows.find(workflow => workflow.id === id);
}

export function getWorkflowsByCategory(category: string): WorkflowConfig[] {
  return workflows.filter(workflow => workflow.category === category);
}

export function getAllCategories(): string[] {
  const categories = workflows.map(workflow => workflow.category).filter(Boolean);
  return Array.from(new Set(categories)) as string[];
}