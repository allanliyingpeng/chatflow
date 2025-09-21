export interface WorkflowConfig {
  id: string;
  title: string;
  description: string;
  difyUrl: string;
  category?: string;
  tags?: string[];
  thumbnail?: string;
  openMode?: 'modal' | 'new_tab';
}

export interface WorkflowsData {
  workflows: WorkflowConfig[];
}